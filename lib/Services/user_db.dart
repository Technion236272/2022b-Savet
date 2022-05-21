import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/auth_repoitory.dart';

int category_id = 0;
int p_id = 0;

class Chat {
  String avatar = '';
  String username = '';
  List<String> from_user = [];
  List<String> to_user = [];
}

class userwithFollowers_Following {
  int followers = 0;
  int following = 0;
  String username = '';
  String avatar_path = '';

  userwithFollowers_Following(int a, int b, String c, String d)
      : followers = a,
        following = b,
        username = c,
        avatar_path = d {}
}

class Comment {
  String avatar_path = '';
  String username = '';
  String content = '';

  Comment(String a_p, String u, String c)
      : avatar_path = a_p,
        username = u,
        content = c {}
}

class Public_Part {
  int likes = 0;
  List<Comment> comments = [];
  List<String> tag = [];
}

class Post {
  bool public = false;
  late Public_Part public_part;
  String content_path = '';
  String title = 'untitled';
  String description = '';
  int cat_id = 0;
  int post_id = 0;

  Post(String t, String d, String c_p, bool p, int c_i)
      : title = t,
        description = d,
        content_path = c_p,
        public = p,
        cat_id = c_i {
    if (p) public_part = Public_Part();
    post_id = p_id;
    p_id++;
  }
}

class Category {
  int cat_id = 0;
  String title = '';
  String description = '';
  String profile_image = '';
  List<Post> posts = [];

  Category(String t, String d, String p_i, List<Post> p)
      : title = t,
        description = d,
        profile_image = p_i,
        posts = p {
    cat_id = category_id;
    category_id++;
  }
}

class UserDB extends ChangeNotifier {
  String username = "";
  String avatar_path = "";

  List<String> notifications = [];

  List<userwithFollowers_Following> followers = [];
  int followers_count = 0;
  List<userwithFollowers_Following> following = [];
  int following_count = 0;

  List<Category> categories = [];

  late DocumentReference userDocument;

  fetchData() async {
    final user = AuthRepository.instance();
    String uid = user.user!.uid;
    uid = 'g72sQSjfyerOS68SxgRV';
    print(uid);
    userDocument = FirebaseFirestore.instance.collection('userID').doc(uid);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

    //fetching username & avatarImage
    username = userData['username'];
    avatar_path = userData['avatar_path'];

    //fetching Notifications
    List<dynamic> notif = userData['notifications'];

    notif.forEach((e) => {notifications.add(e)});

    //fetching list of followers
    List<dynamic> flwrs = userData['followers'];

    flwrs.forEach((e) => {
          followers.add(userwithFollowers_Following(
              e['followers'], e['following'], e['username'], e['avatar_path']))
        });

    //fetching list of followers
    List<dynamic> flwng = userData['following'];

    flwng.forEach((e) => {
          following.add(userwithFollowers_Following(
              e['followers'], e['following'], e['username'], e['avatar_path']))
        });

    addNotification('hi1');
    addNotification('hi2');
    addNotification('hi3');
    addNotification('hi4');
    addNotification('hi5');
  }

  void addNotification(String s) {
    notifications.add(s);
    userDocument.update({'notifications': notifications});
    notifyListeners();
  }

  void addCategory(String t, String d, String p_i, List<Post> p) {
    categories.add(Category(t, d, p_i, p));
    notifyListeners();
  }

  void addPost(String t, String d, String c_p, bool p, int c_i) {
    categories.forEach((e) {
      if (e.cat_id == c_i) {
        e.posts.add(Post(t, d, c_p, p, c_i));
      }
    });
    notifyListeners();
  }

  void addFollower() {}

  void addComment(
      int c_id, int post_id, String a_p, String us, String content) {
    bool flag = false;
    categories.forEach((e) {
      if (e.cat_id == c_id) {
        e.posts.forEach((p) {
          if (p.post_id == post_id) {
            p.public_part.comments.add(Comment(a_p, us, content));
            flag = true;
          }
        });
      }
    });
    ;
    notifyListeners();
    assert(flag);
  }
}