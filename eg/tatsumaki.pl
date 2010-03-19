use Piglet::Helpers qw(:decorators :routes);

use Tatsumaki::MessageQueue;
my $mq = Tatsumaki::MessageQueue->instance('event');

get '/comet/poll/:id' => pig {
    my $self = shift;
    $mq->poll_once(
        $self->req->captures->{id}, sub {
            $self->write(\@_);
            $self->finish;
        },
    );
};

pig_connect 'Tatsumaki';

run;
