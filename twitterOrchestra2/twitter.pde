import java.util.List;

import twitter4j.IDs;
import twitter4j.PagableResponseList;
import twitter4j.ResponseList;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.User;
import twitter4j.UserList;
import twitter4j.conf.*;

final String TWITTER_ACCESS_TOKEN = "2828495274-rBD78hAh9pBM7pbWXWlvEVF0ahAAIB9aJUacIf1";
final String TWITTER_ACCESS_TOKEN_SECRET = "Ulj2YZLSoXxt7fRMq1Fz9VtNkY7WwlV7vYgFSC0Cma9eI";
final String TWITTER_API_KEY = "E4uxrM6Pm2o5nR07tG2AmB8m5";
final String TWITTER_API_SECRET = "ZthLlcyD46LIi47wv7bteJDTt2CMCmVt93fcV20uG0qO5yUKp8";

void twitterInit() {
  connectTwitter(); 
  /*  TwitterStream twitterStream = new TwitterStreamFactory(config()).getInstance();
   UserStreamListenerI listenerI = new  UserStreamListenerI();
   twitterStream.addListener(listenerI);
   //  twitter = login();
   println("login done");
   listenerI.test();
   */
  //  user = twitter.verifyCredentials();
}

List<Status>statuses = null;

TwitterFactory twitterFactory;
Twitter twitter;

boolean printTimeLine  = true;

void connectTwitter() {  

  ConfigurationBuilder cb = new ConfigurationBuilder();  
  cb.setOAuthConsumerKey(TWITTER_API_KEY);
  cb.setOAuthConsumerSecret(TWITTER_API_SECRET);
  cb.setOAuthAccessToken(TWITTER_ACCESS_TOKEN);
  cb.setOAuthAccessTokenSecret(TWITTER_ACCESS_TOKEN_SECRET); 

  twitterFactory = new TwitterFactory(cb.build());    
  twitter = twitterFactory.getInstance();  

  println("connected");
  getTimeline();
  println("#### done");
} 

void getTimeline() {     
  try {        
    statuses = twitter.getHomeTimeline();
  }   
  catch(TwitterException e) {         
    println("Get timeline: " + e + " Status code: " + e.getStatusCode());
  }     
  for (Status status : statuses) {               
    if (printTimeLine)
      println(status.getUser().getName() + ": " + status.getText());
    //    println(status.getUser().getName() + ": " + status.getText());
    serialEvent(status.getText());
  }
} 


/*
Twitter login() {
 ConfigurationBuilder cb = new ConfigurationBuilder();
 cb.setDebugEnabled(true)
 .setOAuthConsumerKey(TWITTER_ACCESS_TOKEN)
 .setOAuthConsumerSecret(TWITTER_ACCESS_TOKEN_SECRET)
 .setOAuthAccessToken(TWITTER_ACCESS_TOKEN)
 .setOAuthAccessTokenSecret(TWITTER_ACCESS_TOKEN_SECRET);
 TwitterFactory tf = new TwitterFactory(cb.build());
 return tf.getInstance();
 }
 */

Configuration config() {
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setDebugEnabled(true)
    .setOAuthConsumerKey("VvdcWIPpCP5N4fxXzeEe3fMuq")
      .setOAuthConsumerSecret(
      "OFMz4TH4zu4gxf9FCkDsqNQTFBGOU49iF1rLCs1OXc3Xyo47Ye")
        .setOAuthAccessToken(
        "2626698878-7j6U2WWteqP8NiW1AlLYsfn8yHnQMtMi1GoEphv")
          .setOAuthAccessTokenSecret(
          "WqUVKcIgiKmDIsNpOufgRMDjP8i9aQ9CEETTPaSLVhUek");
  /*
    .setOAuthConsumerKey(TWITTER_ACCESS_TOKEN)
   .setOAuthConsumerSecret(TWITTER_ACCESS_TOKEN_SECRET)
   .setOAuthAccessToken(TWITTER_ACCESS_TOKEN)
   .setOAuthAccessTokenSecret(TWITTER_ACCESS_TOKEN_SECRET);
   */
  return cb.build();
}

class UserStreamListenerI implements UserStreamListener {


  void test() {
    println("test");
  }

  public void onStatus(Status status) {
    System.out.println("onStatus @" + status.getUser().getScreenName() + " - " + status.getText());
  }

  @Override
    public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }

  @Override
    public void onDeletionNotice(long directMessageId, long userId) {
    System.out.println("Got a direct message deletion notice id:" + directMessageId);
  }

  @Override
    public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    System.out.println("Got a track limitation notice:" + numberOfLimitedStatuses);
  }

  @Override
    public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }

  @Override
    public void onStallWarning(StallWarning warning) {
    System.out.println("Got stall warning:" + warning);
  }

  @Override
    public void onFriendList(long[] friendIds) {
    System.out.print("onFriendList");
    for (long friendId : friendIds) {
      System.out.print(" " + friendId);
    }
    System.out.println();
  }

  @Override
    public void onFavorite(User source, User target, Status favoritedStatus) {
    System.out.println("onFavorite source:@"
      + source.getScreenName() + " target:@"
      + target.getScreenName() + " @"
      + favoritedStatus.getUser().getScreenName() + " - "
      + favoritedStatus.getText());
  }

  @Override
    public void onUnfavorite(User source, User target, Status unfavoritedStatus) {
    System.out.println("onUnFavorite source:@"
      + source.getScreenName() + " target:@"
      + target.getScreenName() + " @"
      + unfavoritedStatus.getUser().getScreenName()
      + " - " + unfavoritedStatus.getText());
  }

  @Override
    public void onFollow(User source, User followedUser) {
    System.out.println("onFollow source:@"
      + source.getScreenName() + " target:@"
      + followedUser.getScreenName());
  }

  @Override
    public void onUnfollow(User source, User followedUser) {
    System.out.println("onFollow source:@"
      + source.getScreenName() + " target:@"
      + followedUser.getScreenName());
  }

  @Override
    public void onDirectMessage(DirectMessage directMessage) {
    System.out.println("onDirectMessage text:"
      + directMessage.getText());
  }

  @Override
    public void onUserListMemberAddition(User addedMember, User listOwner, UserList list) {
    System.out.println("onUserListMemberAddition added member:@"
      + addedMember.getScreenName()
      + " listOwner:@" + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListMemberDeletion(User deletedMember, User listOwner, UserList list) {
    System.out.println("onUserListMemberDeleted deleted member:@"
      + deletedMember.getScreenName()
      + " listOwner:@" + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListSubscription(User subscriber, User listOwner, UserList list) {
    System.out.println("onUserListSubscribed subscriber:@"
      + subscriber.getScreenName()
      + " listOwner:@" + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListUnsubscription(User subscriber, User listOwner, UserList list) {
    System.out.println("onUserListUnsubscribed subscriber:@"
      + subscriber.getScreenName()
      + " listOwner:@" + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListCreation(User listOwner, UserList list) {
    System.out.println("onUserListCreated  listOwner:@"
      + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListUpdate(User listOwner, UserList list) {
    System.out.println("onUserListUpdated  listOwner:@"
      + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListDeletion(User listOwner, UserList list) {
    System.out.println("onUserListDestroyed  listOwner:@"
      + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserProfileUpdate(User updatedUser) {
    System.out.println("onUserProfileUpdated user:@" + updatedUser.getScreenName());
  }

  @Override
    public void onBlock(User source, User blockedUser) {
    System.out.println("onBlock source:@" + source.getScreenName()
      + " target:@" + blockedUser.getScreenName());
  }

  @Override
    public void onUnblock(User source, User unblockedUser) {
    System.out.println("onUnblock source:@" + source.getScreenName()
      + " target:@" + unblockedUser.getScreenName());
  }

  @Override
    public void onException(Exception ex) {
    ex.printStackTrace();
    System.out.println("onException:" + ex.getMessage());
  }
}

UserStreamListener listener = new UserStreamListener() {

  void test() {
    println("test");
  }

  public void onStatus(Status status) {
    System.out.println("onStatus @" + status.getUser().getScreenName() + " - " + status.getText());
  }

  @Override
    public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }

  @Override
    public void onDeletionNotice(long directMessageId, long userId) {
    System.out.println("Got a direct message deletion notice id:" + directMessageId);
  }

  @Override
    public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    System.out.println("Got a track limitation notice:" + numberOfLimitedStatuses);
  }

  @Override
    public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }

  @Override
    public void onStallWarning(StallWarning warning) {
    System.out.println("Got stall warning:" + warning);
  }

  @Override
    public void onFriendList(long[] friendIds) {
    System.out.print("onFriendList");
    for (long friendId : friendIds) {
      System.out.print(" " + friendId);
    }
    System.out.println();
  }

  @Override
    public void onFavorite(User source, User target, Status favoritedStatus) {
    System.out.println("onFavorite source:@"
      + source.getScreenName() + " target:@"
      + target.getScreenName() + " @"
      + favoritedStatus.getUser().getScreenName() + " - "
      + favoritedStatus.getText());
  }

  @Override
    public void onUnfavorite(User source, User target, Status unfavoritedStatus) {
    System.out.println("onUnFavorite source:@"
      + source.getScreenName() + " target:@"
      + target.getScreenName() + " @"
      + unfavoritedStatus.getUser().getScreenName()
      + " - " + unfavoritedStatus.getText());
  }

  @Override
    public void onFollow(User source, User followedUser) {
    System.out.println("onFollow source:@"
      + source.getScreenName() + " target:@"
      + followedUser.getScreenName());
  }

  @Override
    public void onUnfollow(User source, User followedUser) {
    System.out.println("onFollow source:@"
      + source.getScreenName() + " target:@"
      + followedUser.getScreenName());
  }

  @Override
    public void onDirectMessage(DirectMessage directMessage) {
    System.out.println("onDirectMessage text:"
      + directMessage.getText());
  }

  @Override
    public void onUserListMemberAddition(User addedMember, User listOwner, UserList list) {
    System.out.println("onUserListMemberAddition added member:@"
      + addedMember.getScreenName()
      + " listOwner:@" + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListMemberDeletion(User deletedMember, User listOwner, UserList list) {
    System.out.println("onUserListMemberDeleted deleted member:@"
      + deletedMember.getScreenName()
      + " listOwner:@" + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListSubscription(User subscriber, User listOwner, UserList list) {
    System.out.println("onUserListSubscribed subscriber:@"
      + subscriber.getScreenName()
      + " listOwner:@" + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListUnsubscription(User subscriber, User listOwner, UserList list) {
    System.out.println("onUserListUnsubscribed subscriber:@"
      + subscriber.getScreenName()
      + " listOwner:@" + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListCreation(User listOwner, UserList list) {
    System.out.println("onUserListCreated  listOwner:@"
      + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListUpdate(User listOwner, UserList list) {
    System.out.println("onUserListUpdated  listOwner:@"
      + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserListDeletion(User listOwner, UserList list) {
    System.out.println("onUserListDestroyed  listOwner:@"
      + listOwner.getScreenName()
      + " list:" + list.getName());
  }

  @Override
    public void onUserProfileUpdate(User updatedUser) {
    System.out.println("onUserProfileUpdated user:@" + updatedUser.getScreenName());
  }

  @Override
    public void onBlock(User source, User blockedUser) {
    System.out.println("onBlock source:@" + source.getScreenName()
      + " target:@" + blockedUser.getScreenName());
  }

  @Override
    public void onUnblock(User source, User unblockedUser) {
    System.out.println("onUnblock source:@" + source.getScreenName()
      + " target:@" + unblockedUser.getScreenName());
  }

  @Override
    public void onException(Exception ex) {
    ex.printStackTrace();
    System.out.println("onException:" + ex.getMessage());
  }
};

