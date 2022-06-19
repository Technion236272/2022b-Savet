import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/similar_content_card.dart';
import 'package:savet/Posts/videoPlayer.dart';

import '../../Services/user_db.dart';
import '../edit_post.dart';
import '../similar_content.dart';

class private_post extends StatefulWidget {
  private_post(
      {Key? key, required this.cat_id, required this.post_id, this.user})
      : super(key: key);
  Map? user;
  int cat_id;
  int post_id;
  var date;
  @override
  _private_postState createState() => _private_postState();
}

class _private_postState extends State<private_post> {
  List<String> arr = [
    'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
    'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
    'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
    'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/01/29/17/09/snowboard-4803050_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/02/06/20/01/university-library-4825366_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/11/22/17/28/cat-5767334_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/13/16/22/snow-5828736_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg',
  ];
  String _setTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    print(_setTime);
    List posts = (widget.user != null)
        ? widget.user!['categories'][widget.cat_id]['posts']
        : Provider.of<UserDB>(context).categories[widget.cat_id]['posts'];
    Map post = {
      'title': "",
      'image':
          "https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg",
      'cat_id': widget.cat_id,
      'id': widget.post_id,
      'description': "",
      'date': widget.date,
      'time': _setTime
    };
    for (var e in posts) {
      print(e['id']);
      if (e['id'] == widget.post_id) {
        post = e;
        String te = e['date'];
        print(te);
        if (te != null && te != "") {
          widget.date = DateFormat('MM/dd/yyyy').parse(te);
          String t = e['time'];
          if (t != null) _setTime = t;
          // widget.date = DateFormat.yMd().format(e['reminder']);
          //DateTime.tryParse(te);
          print(widget.date);
          print(widget.date);
          break;
        }
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(post['title']),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => edit_post(
                                          post_id: widget.post_id,
                                          cat_id: widget.cat_id,
                                        )));
                          },
                          child: Text("Edit"),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () async {
                            //print(widget.date);
                            await showDatePicker(
                                    context: context,
                                    initialDate: widget.date ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050))
                                .then((value) async {
                              if (value != null) {
                                var time = await showTimePicker(
                                    initialEntryMode: TimePickerEntryMode.input,
                                    context: context,
                                    initialTime: TimeOfDay(
                                      hour: int.parse(_setTime.split(":")[0]),
                                      minute: int.parse(
                                          _setTime.split(":")[1].split(" ")[0]),
                                    ));
                                if (time != null) {
                                  Provider.of<UserDB>(context, listen: false)
                                      .changeDate(
                                          widget.cat_id,
                                          widget.post_id,
                                          DateFormat.yMd().format(value),
                                          time.format(context));

                                  setState(() {
                                    _setTime = time.format(context);
                                    print(value);
                                    widget.date = value;
                                  });
                                }
                                print(value);
                              }
                            });
                            Navigator.pop(context);
                          },
                          //prefixIcon: Icon(Icons.add_alert),
                          child: Text(
                            'Reminder',
                            //style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Post"),
                                    content: const Text(
                                        "Are you sure you want to delete this post?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Yes"),
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.deepOrange)),
                                        onPressed: () {
                                          setState(() {
                                            Provider.of<UserDB>(context,
                                                    listen: false)
                                                .removePost(
                                                    post['id'], post['cat_id']);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("No"),
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.deepOrange)),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  );
                                });
                          },
                          // icon: const Icon(Icons.delete),
                          child: Text(
                            'Delete',
                            //style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ]),
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          child: Column(
            children: [
              (post['videoFlag'])
                  ? VideoPlayerScreen(networkFlag: true, url: post['image'])
                  : Image(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      image: NetworkImage(post['image'])),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: Text(
                  post['description'],
                  style: const TextStyle(
                      fontFamily: 'arial',
                      decoration: TextDecoration.none,
                      color: Colors.black54,
                      fontSize: 15),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "   Similar Content",
                        style: const TextStyle(
                            fontFamily: 'arial',
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const similar_content()));
                          },
                          child: const Text("VIEW ALL",
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 13)))
                    ],
                  ),
                  Container(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(10, (index) {
                              return similar_content_card(url: arr[index]);
                            }),
                          )))
                ],
              ))
            ],
          ),
        )));
  }

  Future<DateTime?> _getDateFromeUser() async {
    print(widget.date);
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: widget.date ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (_pickerDate != null) {
      setState(() {
        widget.date = _pickerDate;
      });
      return _pickerDate;
    } else {
      return null;
    }
  }

  Future<DateTime?> _getTimeFromeUser() async {
    print(widget.date);
    var _time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
    );
  }
}
