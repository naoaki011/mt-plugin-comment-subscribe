package CommentSubscribe::Util;

use strict;
use warnings;
use MT::App::Comments;
use base 'Exporter';
our @EXPORT_OK = qw( send_notifications );

sub send_notifications {
    my ($obj,$base) = @_;

#    my $app      = MT::App::Comments->instance;
#    $app->mode('comment_subscribe_worker');
    my $plugin   = MT->component('CommentSubscribe');
    my $blog_id  = $obj->blog_id;
    my $entry_id = $obj->entry_id;
    my $email    = $obj->email;
#    $base        ||= $app->base;

    # Get entry details
    my $entry = MT->model('entry')->load({
        'blog_id' => $blog_id,
        'id'      => $entry_id
    });
    
    my $from_email = $entry->author()->email;
    my $blog       = $entry->blog;
    
    # Send email
    my @addresses = MT->model('commentsubscriptions')->load({
        'blog_id'  => $blog_id,
        'entry_id' => $entry_id
    });
    
    # Changed to use translate method for L10N
    my $subject =
        $plugin->translate( "([_1]) [_2] posted a new comment on '[_3]'",
                            $blog->name, $obj->author, $entry->title );
    
    require MT::Mail;
    foreach my $addy (@addresses) {
        my %head = (
            To      => $addy->email,
            Subject => $subject,
            
            # Added a from of either the system email or commenter email
            # (previously it would use root server email)
            From =>
            $from_email  #$app->config('EmailAddressMain') || $addy->email
            );
        
        # Here we build the email from a template rather than raw text. 
        # More powerful, easier to edit, L10N
        my $param = {
            entry_title     => $entry->title,
            entry_permalink => $entry->permalink,
            comment_author  => $obj->author,
            comment_text    => $obj->text,
            unsub_link      => $base
                . "?__mode=unsub&key="
                . $addy->uniqkey
        };
        # load_tmpl loads it from the plugin's tmpl directory
        my $tmpl = $plugin->load_tmpl('commentsubscribe_notify.tmpl', $param);
        my $body = $tmpl->output;
        
        if ( $addy->email ne $email ) {    # Don't sent to the commenter
            if ( MT->config->DebugMode > 0 ) {
                MT->log(
                    {
                        blog_id => $blog->id,
                        message => "Sending comment notification to: "
                            . $head{'To'}
                    }
                    );
            }
            MT::Mail->send( \%head, $body );
        } else {
            if ( MT->config->DebugMode > 0 ) {
                MT->log(
                    {
                        blog_id => $blog->id,
                        message => "NOT sending comment notification to: "
                            . $head{'To'} . " because subscriber is the same as the commenter."
                    }
                    );
            }
        }
    }
}

1;
