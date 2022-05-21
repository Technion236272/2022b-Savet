import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

import 'add_category.dart';

class category extends StatefulWidget {
  const category({Key? key}) : super(key: key);

  @override
  _categoryState createState() => _categoryState();
}

void takePhoto(ImageSource source, ImagePicker _picker) async {
  final pickedFile = await _picker.pickImage(
    source: source,
  );
  //uploadpickedFile!.path
}

Widget imageProfile(BuildContext context, ImagePicker _picker) {
  return Center(
    child: Stack(children: <Widget>[
      CircleAvatar(
          radius: 70.0,
          backgroundImage: NetworkImage("https://i.ibb.co/CwTL6Br/1.jpg")),
      Positioned(
        bottom: 10.0,
        right: 15.0,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: ((builder) => bottomSheet(context, _picker)),
            );
          },
          child: Icon(
            Icons.camera_alt,
            color: Colors.black87,
            size: 28.0,
          ),
        ),
      ),
    ]),
  );
}

Widget bottomSheet(BuildContext context, ImagePicker _picker) {
  return Container(
    height: 100.0,
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child: Column(
      children: <Widget>[
        const Text(
          "Choose Profile photo",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.camera),
            onPressed: () {
              takePhoto(ImageSource.camera, _picker);
              Navigator.pop(context);
            },
            label: Text("Camera"),
          ),
          TextButton.icon(
            icon: Icon(Icons.image),
            onPressed: () {
              takePhoto(ImageSource.gallery, _picker);
              Navigator.pop(context);
            },
            label: Text("Gallery"),
          ),
        ])
      ],
    ),
  );
}

class _categoryState extends State<category> {
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
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cat Name"),
          //automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => add_category())),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(children: [
          SizedBox(height: 10),
          imageProfile(context, _picker),
          SizedBox(height: 10),
          Text(
            "Cat Name",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: AutoSizeText(
              "Description _____________________________________________________________________________________",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Flexible(
            child: StaggeredGrid.count(
              crossAxisCount: 3,
              children: List.generate(10, (index) {
                return Container(
                  padding: EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: arr[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
            ),
          ),
        ]));
  }
}
