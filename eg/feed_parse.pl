use Piglet::Helpers qw(:routes);
use Piglet::Helpers::View qw(zoom);

use XML::Feed;
use URI;
use HTTP::Exception;

get '/feed/:id' => sub {
    my $req = shift;

    my $feed = XML::Feed->parse(URI->new("http://friendfeed.com/" . $req->capture('id') . "?format=atom"))
        or HTTP::Exception::NOT_FOUND->throw;

    zoom {
        my $z = shift;
        $z->select('title, .title')->replace_content("Feed for " . $req->capture('id'))
          ->select('.entries')->repeat_content([
            map {
                my $e = $_;
                sub { $_->select('a')->replace_content($e->title) };
            } $feed->entries
        ])->to_html;
    };
};

run;

__DATA__

@@ feed.html.zoom
<html>
 <head><title></title></head>
 <body>
  <h1 class="title" />
  <ul>
   <li><a /></li>
  </ul>
 </body>
</html>
