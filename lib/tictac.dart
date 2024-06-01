// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TicTac extends StatefulWidget {
  const TicTac({super.key});

  @override
  State<TicTac> createState() => _TicTacState();
}

class _TicTacState extends State<TicTac> {

  Color baseColor = Color(0xFFF2F2F2);
  int O_wins=0;
  int X_wins=0;
  int filled=0;
  String currentPlayer='O';
  List highlightIndex=[];

  List value=['*','*','*','*','*','*','*','*','*'];


  checkPlaces(v1,v2,v3){

    if (value[v1]!='*' && value[v1]==value[v2] && value[v1]==value[v3]){
      highlightIndex.addAll([v1,v2,v3]);
      return true;
    }

    return false;
  }

  checkWin(){

    // Row check
    if (checkPlaces(0,1,2) || checkPlaces(3,4,5) || checkPlaces(6,7,8)){
      return true;
    }

    // Column check
    else if (checkPlaces(0,3,6) || checkPlaces(1,4,7) || checkPlaces(2,5,8)){
      return true;
    }

    // Diagonal Check
    else if (checkPlaces(2,4,6) || checkPlaces(0,4,8)){
      return true;
    }

    else{
      return false;
    }
  }

  reset(){

    currentPlayer='O';
    filled=0;
    value=['*','*','*','*','*','*','*','*','*'];
    highlightIndex=[];
    setState(() {});

  }
  
  setvalue(index){

    value[index]=currentPlayer;
    setState(() {});

    var result=checkWin();

    if (result){

      Get.snackbar('Yay Player : ${currentPlayer}', 'You won this round',icon: Icon(Icons.celebration_rounded),shouldIconPulse: true,snackPosition: SnackPosition.BOTTOM,margin: EdgeInsets.all(20));
      
      currentPlayer=='O'?O_wins+=1:X_wins+=1;

      Future.delayed(Duration(milliseconds: 3500),(){
        reset();
      });
    
    }
    
    else{

      filled+=1;
      currentPlayer=currentPlayer=='O'?'X':'O';

      if (filled==9){
        Get.snackbar('Round Draw', 'Start new one',icon: Icon(Icons.restart_alt_sharp),shouldIconPulse: true,snackPosition: SnackPosition.BOTTOM,margin: EdgeInsets.all(20));
        reset();
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height:80),
            Text('TIC TAC TOE',style: TextStyle(fontSize: 38,fontWeight: FontWeight.bold),),
            SizedBox(height: 60,),
            
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('O Wins : ${O_wins}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              Text('X Wins : ${X_wins}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                ],
              ),

            SizedBox(height: 20,),
            Center(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
                itemCount: 9,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      if (value[index]=='*'){
                        setvalue(index);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClayContainer(
                          color: baseColor,
                          borderRadius: 10,
                          child: Stack(
                            children: [
                              Center(child: Text('${value[index]}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),)),
                              highlightIndex.contains(index)?SpinKitCircle(color: Colors.redAccent,):Container()
                            ],
                          )),
                        ),
                  );
                }),
            ),
          
          SizedBox(height: 40,),
            highlightIndex.isNotEmpty?ClayContainer(
              height: 65,
              width: 65,
              borderRadius: 60,
               curveType: CurveType.concave,
               child: SpinKitRipple(itemBuilder: (context,index){return Icon(FontAwesomeIcons.solidHeart,color: Colors.redAccent,size: 50,);},),
            ):Container(),
          ],
        ),
      ) ,
    );
  }
}