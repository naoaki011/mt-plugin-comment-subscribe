package CommentSubscribe::EmailWorker;

use strict;
use base qw( TheSchwartz::Worker );

use TheSchwartz::Job;
use CommentSubscribe::Util qw( send_notifications );

sub keep_exit_status_for { 1 }

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    # Build this
#    my $app = MT::App::Comments->new();
#    $app->init();
    
    my @jobs = ($job);
    my $job_iter;
    if (my $key = $job->coalesce) {
        $job_iter = sub {
            shift @jobs || MT::TheSchwartz->instance->find_job_with_coalescing_value($class, $key);
        };
    }
    else {
        $job_iter = sub { shift @jobs };
    }

    while (my $job = $job_iter->()) {
        my $comment_id = $job->uniqkey;
        my $comment = MT->model('comment')->load($comment_id);
        unless ($comment) {
            $job->completed();
            next;
        }
        $job->debug("Sending comment notification emails for comment #" . $comment->id);
        send_notifications( $comment, $job->arg );
        $job->completed();

    }

#    if ($rebuilt) {
#        MT::TheSchwartz->debug($mt->translate("-- set complete ([quant,_1,file,files] in [_2] seconds)", $rebuilt, sprintf("%0.02f", tv_interval($start))));
#    }

}

sub grab_for { 60 }
sub max_retries { 0 }
sub retry_delay { 0 }

1;
