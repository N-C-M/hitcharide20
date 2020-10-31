import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:workavane/brand_colors.dart';
import 'package:workavane/datamodels/prediction.dart';

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  PredictionTile({this.prediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
        Icon(OMIcons.locationOn,color: BrandColors.colorDimText,),
      SizedBox(
        width:12,
      ),

      Column(            
        
        crossAxisAlignment: CrossAxisAlignment.start,

        children:<Widget> [

        Text(prediction.mainText,style: TextStyle(fontSize: 16),),
        SizedBox(height:2,),
        Text(prediction.secondaryText,style: TextStyle(fontSize: 12,color: BrandColors.colorLightGray),),


      ],
      ),

      ],
      
      ),
    );
  }
}
