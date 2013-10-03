package CommentSubscribe::Util;

use strict;
use warnings;
use MT::App::Comments;
use MT::Util qw( trim );
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
    my $custom_from = trim( $plugin->get_config_value('from_header') );
    if ($custom_from && $custom_from ne '') { 
        $from_email = $custom_from;
    }

    my $blog       = $entry->blog;
    
    # Send email
    my @addresses = MT->model('commentsubscriptions')->load({
        'blog_id'  => $blog_id,
        'entry_id' => $entry_id
    });
    
    my $subject = trim( $plugin->get_config_value('subject_header') );
    $subject =~ s/%BLOG%/$blog->name/e;
    $subject =~ s/%COMMENTER%/$obj->author/e;
    $subject =~ s/%TITLE%/$entry->title/e;

    #$plugin->translate( "([_1]) [_2] posted a new comment on '[_3]'",
    #                    $blog->name, $obj->author, $entry->title );
    
    require MT::Mail;
    foreach my $addy (@addresses) {
        my %head = (
            'To'          => $addy->email,
            'Subject'     => $subject,
            'From'        => $from_email,
            'Return-Path' => $from_email,
            );
        
        # Here we build the email from a template rather than raw text. 
        # More powerful, easier to edit, L10N
        my $param = {
            entry_title        => $entry->title,
            entry_author       => $entry->author->name,
            entry_author_email => $entry->author->email,
            entry_permalink    => $entry->permalink,
            comment_author     => $obj->author,
            comment_text       => $obj->text,
            unsub_link         => $base
                . "?__mode=unsub&key="
                . $addy->uniqkey
        };

        my $body = MT->build_email( 'commentsubscribe_notify', $param );
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
            MT::Mail->send( \%head, $body ) or 
                MT->log(
                    {
                        class   => 'error',
                        blog_id => $blog->id,
                        message => "Failed sending comment notification: " .  MT::Mail->errstr,
                    }
                    );
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
