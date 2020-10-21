import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pictures.dart';
import '../widgets/images_grid.dart';

class ViewImages extends StatelessWidget {
  static const routeName = '/view-images';
  @override
  Widget build(BuildContext context) {
    return Container(
        child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children :[ImagesGrid(),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,


          children: [
            FloatingActionButton(
                heroTag: "btn1",
                child: Icon(Icons.face),
                backgroundColor: Colors.indigo,
                onPressed: (){
                  print('test');

                }),

            SizedBox(
              width: 100,
            ),

            FloatingActionButton(
                heroTag: "btn2",
                child: Icon(Icons.delete_forever),
                backgroundColor: Colors.indigo,
                onPressed: (){
                  Provider.of<Pictures>(context,listen: false).deleteImages();

                })
          ],
        ),

  ],)
    );
  }
}