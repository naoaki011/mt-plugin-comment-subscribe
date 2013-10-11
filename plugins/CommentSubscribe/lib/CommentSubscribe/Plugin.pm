package CommentSubscribe::Plugin;

use strict;
use String::Random qw( random_string );
use CommentSubscribe::Util qw( send_notifications ); 

sub process_new_comment {
    my ( $cb, $obj, $original ) = @_;

    my $plugin = MT->component('CommentSubscribe');

    # If the object is visible ("published"), then this is not spam.
    # Check for spam content first! This way, the CommentSubscribe
    # table isn't flooded with spam email addresses.

    if ( $obj->is_not_junk ) {

        my $app = MT->instance()
          ;    # Store the instance in a variable, we need it more often

        my $blog_id  = $obj->blog_id;
        my $entry_id = $obj->entry_id;
        my $email    = $obj->email;

        if ( $app->param('subscribe') && $email ) {

            # don't bother if the user hasn't left an email address 
            # or if the comment is not yet visible
            if (
                !MT->model('commentsubscriptions')->load(
                    {
                        'blog_id'  => $blog_id,
                        'entry_id' => $entry_id,
                        'email'    => $email
                    }
                )
              )
            {
                my $csub = MT->model('commentsubscriptions')->new;
                my $rand = random_string('000000000000',[ 'A'..'Z', 'a'..'z' ]);
                $csub->blog_id($blog_id);
                $csub->entry_id($entry_id);
                $csub->email($email);
                $csub->uniqkey($rand);
                $csub->save;
            }
        }

        if ( $obj->visible ) {
            my $use_queue = $plugin->get_config_value('use_queue');
            if ( $use_queue ) {
                require MT::TheSchwartz;
                require TheSchwartz::Job;
                my $job = TheSchwartz::Job->new();
                $job->funcname('CommentSubscribe::EmailWorker');
                $job->uniqkey( $obj->id );
                my $priority = 5;
                $job->priority( $priority );
                $job->coalesce( ( $obj->blog_id || 0 ) .':'.$$.':'.$priority.':'.( time - ( time % 10 ) ) );
                $job->arg( $app->base . $app->uri );
                MT::TheSchwartz->insert($job);
            } else {
                send_notifications( $obj );
            }
        }
    }
    else {
        if ( $plugin->get_config_value('remove_junk') ) {
            my $blog_id  = $obj->blog_id;
            my $entry_id = $obj->entry_id;
            my $email    = $obj->email;
            if ( $email ) {
                my $subscription = MT->model('commentsubscriptions')->load(
                    {
                        'blog_id'  => $blog_id,
                        'entry_id' => $entry_id,
                        'email'    => $email
                    }
                );
                $subscription->remove if $subscription;
            }
        }
    }
}

sub unsub {
    my $app = shift;

    my $key    = $app->{query}->param('key');
    my $plugin = MT->component('CommentSubscribe');

    if ($app->{query}->param('id')) {
        return $app->error("Our apologies, but the unsubscribe link you clicked on has been disabled for security reasons. To unsubscribe from this blog, please wait for another comment notification email with an updated link, or contact the system administrator. We sincerely apologize for this inconvenience.");
    } elsif ($key) {
        my $obj   = MT->model('commentsubscriptions')->load({ uniqkey => $key });
        my $entry = MT->model('entry')->load( $obj->entry_id );
        my $blog  = MT->model('blog')->load( $obj->blog_id );
        MT->log(
            {
                blog_id => $blog->id,
                message => "Unsubscribing "
                  . $obj->email
                  . " from "
                  . $entry->title
            }
        );
        $obj->remove();
        return $app->build_page(
            $plugin->load_tmpl('commentsubscribe_unsub.tmpl'),
            {
                entry_title => $entry->title,
                entry_url   => $entry->permalink,
                blog_name   => $blog->name
            }
        );
    }

    return "I'm afraid I don't understand that.";
}

#sub load_tasks {
#    my $cfg = MT->config;
#    return {
#        'SendCommentSubscribeNotifications' => {
#            'label'     => 'Send Comment Notifications',
#            'frequency' => 5 * 60, # 5 minutes
#            'code'      => sub {
#                CommentSubscribe::Plugin->task_send;
#            },
#        }
#    };
#}
#
#sub task_send {
#    my $this = shift;
#    require MT::Util;
#    my $app           = MT->instance;
#    my $total_changed = 0;
#    my @blogs         = MT->model('blog')->load(
#        undef,
#        {
#            join => MT->model('entry')->join_on(
#                'blog_id',
#                {
#                    status    => MT::Entry::RELEASE(),
#                    expire_on => { not_null => 1 },
#                },
#                { unique => 1 }
#            )
#        }
#    );
#}

1;
