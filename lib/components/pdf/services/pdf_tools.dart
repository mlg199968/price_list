
class PdfTools{


static List<List> extractByCategory(List<Map> dataList,String category){
  List<List> newList=[];
  dataList.forEach((element) {if(element["category"]==category){newList.add(element["data"]);}});
  print(newList);
  return newList;
}


  // static List<Ware> sortGroups(List<Ware> wareList){
  //   List<Ware> sortedList=[];
  //   List groupList=Provider.of<WareProvider>(GlobalTask.navigatorState.currentContext!,listen: false).groupList;
  //   for(String group in groupList){
  //     for(Ware ware in wareList){
  //       if(ware.groupName==group){
  //         sortedList.add(ware);
  //       }
  //     }
  //   }
  //   return sortedList;
  // }
}