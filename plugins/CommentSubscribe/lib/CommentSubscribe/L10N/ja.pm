package CommentSubscribe::L10N::ja;

use strict;
use base 'CommentSubscribe::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

    'Allows viewers to subscribe to recieve emails every time a comment is posted for a given entry.'
      => 'エントリーにコメントが投稿されたときに、そのコメントをメールで受信できるようにします。',
    "([_1]) [_2] posted a new comment on '[_3]'" => "([_1]) [_2] さんからブログ記事「[_3]」にコメントがありました。",
    "There's a new comment on '[_1]'" => "ブログ記事「[_1]」に新しいコメントがありました。",
    'If you no longer wish to receive notifications, please click here' => 'コメントの通知メールの送信を止めたい場合は、次のアドレスをクリックしてください。',
    'If you no longer wish to receive notifications of new comments, please click or cut and paste the following URL into a web browser'
      => '新規コメントの通知メール送信を止めたい場合は、次のURLをクリックするかブラウザーに貼り付けてください。',
    'You have successfully unsubscribed from future comment notifications from [_1].' => '[_1]に対する、以後のコメントのメール通知が、正常に解除されました。',
    'Unsubscribed' => '通知が解除されました。',
);

1;
