個人的にtwitterのツイートを削除したかったので。

keys.csvにhttps://dev.twitter.com/にて取得したキーやらアクセストークンやらを
以下の書式に従って書き込む。

consumer key,consumer secret,access token,access secret,user name

引数無しで1ツイートずつ、確認して削除。
引数 -d を与えるとツイートがある限り確認せず削除していく。API制限の範囲とか考えてないので止めたり再開したりと。