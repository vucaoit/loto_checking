import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  RxList<RxBool> list = RxList();
  RxList<RxBool> listTicket = RxList();
  List<List<int>> listnumber = [];
  RxList<int> store = RxList();
  RxList<int> stt = RxList([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]);
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 90; i++) {
      list.add(false.obs);
    }
    for (int i = 0; i < 16; i++) {
      listTicket.add(false.obs);
    }
    addlist(listnumber);
    return WillPopScope(
        onWillPop: () async {
          print("click back");
          showAlertDialog(context);
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    height: 500,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        direction: Axis.vertical,
                        children:
                            createListCheckBok(list, listnumber, listTicket),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Obx(()=>Wrap(
                      runSpacing: 5,
                      alignment: WrapAlignment.spaceAround,
                      children: createTicket(listTicket, listnumber),
                    )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Reset"),
      onPressed:  () {
        reset();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert Dialog"),
      content: Text("Would you like to reset list numbers?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  List<Widget> createRow(int to, List<int> list) {
    List<Widget> newlist = [];
    List<int> temp = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (int i in list) {
      if (i == 90) {
        temp[8] = i;
      } else {
        temp[i ~/ 10] = i;
      }
    }
    for (int i = 0; i < temp.length; i++) {
      if (temp[i] != 0) {
        newlist.add(Container(
          color: (store.indexOf(temp[i]) != -1 && listTicket[to].value)
              ? Colors.red
              : Colors.white,
          child: Text(
            '${temp[i]}',
            style: TextStyle(color: (store.indexOf(temp[i]) != -1 && listTicket[to].value)
                ? Colors.white
                : Colors.black,fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ));
      } else {
        newlist.add(Container(
          color: (listTicket[to].value)
              ? Colors.green.withOpacity(0.7)
              : Colors.white,
          child: Text(''),
        ));
      }
    }
    return newlist;
  }
 reset(){
    for(RxBool bo in list){
      bo.value=false;
    }
    store.clear();
 }
  List<TableRow> createTable(List<int> list, int to) {
    List<TableRow> newlist = [];
    for (int i = 0; i < list.length; i += 5) {
      List<int> temp = [];
      for (int j = i; j < i + 5; j++) temp.add(list[j]);
      newlist.add(TableRow(children: createRow(to, temp)));
    }
    newlist;
    return newlist;
  }

  List<Widget> createTicket(
      RxList<RxBool> listTick, List<List<int>> listnumber) {
    List<Widget> list = [];
    for (int k=0;k<stt.length;k++) {
      int i=stt[k];
      List<int> numofticket = listnumber[i];
      list.add(GestureDetector(
        onTap: () {
          int count=0;
          for(RxBool b in listTick){
            if(b.value)count++;
          }
          listTick[i].value = !listTick[i].value;
          if( listTick[i].value){
            int temp = stt[count];
            stt[count]=i;
            stt[k]=temp;

          }
          else{
            stt.removeAt(k);
            stt.insert(count-1, i);
          }
        },
        child: Obx(() => Container(
              width: 190,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: Colors.black),
              ),
              child: Stack(
                children: [
                  Table(
                      border: TableBorder
                          .all(), // Allows to add a border decoration around your table
                      children: createTable(numofticket, i)),
                ],
              ),
            )),
      ));
    }
    return list;
  }

  List<Widget> createListCheckBok(RxList<RxBool> rxList,
      List<List<int>> listnumber, RxList<RxBool> listTicket) {
    List<Widget> listwidget = [];
    for (int i = 0; i < 90; i++) {
      listwidget.add(TextButton(
          onPressed: () {
            rxList[i].value = !rxList[i].value;
            if (store.indexOf(i + 1) != -1) {
              store.remove(i + 1);
            } else {
              store.add(i + 1);
            }
            if (rxList[i].value) checkWin(i, listnumber, rxList, listTicket);
          },
          child: Obx(() => Text(
                "${i + 1}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: rxList[i].value ? Colors.red : Colors.blue),
              ))));
    }
    return listwidget;
  }

  bool checkWin(int number, List<List<int>> listnumber, RxList<RxBool> list,
      RxList<RxBool> listTicket) {
    bool isWin = false;
    List<List<int>> listRowWin = [];
    for (int i = 0; i < 16; i++) {
      if (listTicket[i].value) {
        List<int> temp = listnumber[i]; //lay ra danh sach con so cua to loto
        for (int i = 0; i < temp.length; i += 5) {
          List<int> row = [
            temp[i],
            temp[i + 1],
            temp[i + 2],
            temp[i + 3],
            temp[i + 4]
          ];
          bool win = true;
          for (int j = i; j < i + 5; j++) {
            if (store.indexOf(temp[j]) == -1) win = false;
          }
          if (win) {
            listRowWin.add(row);
          }
        }
      }
    }
    if (listRowWin.isNotEmpty) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('WIN'),
                content: Text('$listRowWin'),
              ));
      return true;
    }
    return isWin;
  }

  addlist(List<List<int>> listnumber) {
    listnumber.add([7,16,32,66,73,18,29,46,55,88,2,23,34,50,75,4,30,40,61,78,10,27,41,56,86,20,39,59,60,83,9,24,51,64,81,3,28,48,53,80,17,37,45,63,77]);
    listnumber.add([19,35,49,71,85,8,14,47,54,74,6,25,36,62,84,15,22,58,70,89,12,31,43,68,90,1,42,65,72,87,5,21,38,52,76,13,33,57,67,82,11,26,44,69,79]);
    listnumber.add([19,32,58,64,84,13,20,48,55,77,2,21,46,75,82,6,18,39,62,70,25,41,59,74,83,17,38,44,60,86,8,22,47,66,72,9,12,37,42,88,15,36,51,68,90]);
    listnumber.add([5,29,30,56,80,10,35,54,63,81,4,26,45,61,79,3,14,43,50,71,7,23,31,52,73,11,28,49,69,89,24,34,53,67,85,27,40,57,76,87,1,16,33,65,78]);
    listnumber.add([16,28,45,68,87,4,29,35,55,73,9,30,54,62,88,1,21,33,52,76,8,40,50,79,81,11,20,46,63,83,27,49,59,72,80,2,19,32,48,67,14,22,57,78,90]);
    listnumber.add([6,18,47,69,86,13,31,44,61,70,7,24,34,56,71,5,23,41,65,74,10,37,53,60,89,17,38,42,75,84,15,25,51,77,85,12,36,43,64,82,3,26,39,58,66]);
    listnumber.add([18,22,55,76,87,12,38,40,66,82,1,27,42,73,85,10,34,56,63,80,6,35,43,64,71,13,21,54,74,90,7,24,32,53,67,2,36,47,65,72,11,23,45,51,81]);
    listnumber.add([19,28,46,68,75,5,26,39,58,78,14,37,50,69,84,3,25,57,60,86,16,31,49,77,89,8,17,48,59,79,15,20,44,52,70,4,33,41,61,83,9,29,30,62,88]);
    listnumber.add([3,15,32,60,71,10,20,43,54,85,2,26,35,59,76,6,39,49,68,73,13,29,48,50,88,22,30,53,65,82,1,25,58,69,90,7,21,41,56,87,11,37,44,61,70]);
    listnumber.add([12,34,40,75,89,8,16,42,55,77,5,24,33,67,83,14,27,51,78,84,18,38,46,63,81,9,47,66,79,86,4,28,31,57,72,17,36,52,64,80,19,23,45,62,74]);
    listnumber.add([15,24,44,64,79,4,29,30,51,76,17,32,53,63,80,7,23,56,61,85,11,34,42,72,87,3,13,45,54,74,16,21,43,58,78,6,37,40,65,82,2,22,39,67,83]);
    listnumber.add([14,28,50,75,90,19,31,49,68,81,5,20,47,77,84,12,38,55,69,89,1,36,41,66,71,18,26,57,70,88,8,25,33,52,62,9,35,46,60,73,10,27,48,59,86]);
    listnumber.add([11,35,59,68,80,17,24,42,57,76,1,27,48,79,81,7,16,31,65,77,23,44,50,71,85,14,37,49,63,88,3,20,46,67,73,8,12,34,45,87,19,39,55,60,89]);
    listnumber.add([9,25,38,53,86,15,36,51,64,90,2,28,47,66,78,5,10,41,56,72,4,22,33,54,74,13,26,40,61,82,29,30,58,62,83,21,43,52,75,84,6,18,32,69,70]);
    listnumber.add([9,16,46,65,80,11,32,45,68,78,8,21,33,57,73,6,20,43,63,77,12,31,54,62,85,19,39,40,70,82,18,29,58,74,90,17,38,44,69,88,2,27,37,55,67]);
    listnumber.add([13,22,41,61,86,3,24,34,52,71,1,35,56,64,83,7,23,36,53,75,5,48,59,72,84,14,28,42,60,87,26,47,50,79,89,4,10,30,49,66,15,25,51,76,81]);
  }
}
