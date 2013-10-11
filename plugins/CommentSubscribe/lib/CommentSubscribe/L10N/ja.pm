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
    'You have successfully unsubscribed from future comment notifications of [_1].' => '[_1]に対する、以後のコメントのメール通知が、正常に解除されました。',
    'Unsubscribed' => '通知が解除されました。',
    'Comment Notification to Subscribers' => '購読者へのコメント通知',
    'Send email notifications for new comments.' => '新規コメントへの通知メールを送ります。',
    'Populating unique keys...' => '一意のキーを登録中...',
    'Send notifications via background task?' => 'キュー経由で送信',
    'Send emails from?' => '送信元アドレス',
    'Email Subject' => '送信メール件名',
    'The email address comment notification emails will be sent from. Leave this field blank if you wish comment notification emails to be sent from the author of the entry.'
      => 'コメント通知メールの送信元アドレスとして指定します。 空白の場合は、コメント先記事の投稿者のメールアドレスが利用されます。',
    'The subject of the email that will be sent.<br>%BLOG% = Blog Name<br>%COMMENTER% = Commenter Name<br>%TITLE% = Blog post title'
      => '送信されるメール件名を設定します。<br>%BLOG% = ブログ名<br>%COMMENTER% = コメント投稿者名<br>%TITLE% = 記事タイトル',
    'Remove subscription' => '購読の削除',
    'Remove subscribe at Comment set to junk.' => 'コメントがスパム指定された時に、そのユーザの登録を解除します。',
);

1;
