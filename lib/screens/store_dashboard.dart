import 'package:mooweapp/export_files.dart';
// enum Page { dashboard, manage }

class StoreDashboard extends StatefulWidget {
  const StoreDashboard({Key? key}) : super(key: key);

  @override
  State<StoreDashboard> createState() => _StoreDashboardState();
}

class _StoreDashboardState extends State<StoreDashboard> {
  Color active = kPrimaryColor;

  MaterialColor notActive = Colors.grey;

  TextEditingController categoryController = TextEditingController();

  TextEditingController brandController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          color: kPrimaryColor,
          height: 100,
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                      child: Card(
                    child: ListTile(
                        title: ElevatedButton.icon(
                            onPressed: null, icon: const Icon(Icons.track_changes), label: const Text("Producs")),
                        subtitle: Text(
                          storeController.storeProducts.value.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  )),
                ],
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Card(
              //         child: ListTile(
              //             title: ElevatedButton.icon(
              //               onPressed: null,
              //               icon: const Icon(Icons.category),
              //               label: const Text("Categories"),
              //             ),
              //             subtitle: Text(
              //               storeController.categories.value.length.toString(),
              //               textAlign: TextAlign.center,
              //               style: TextStyle(color: active, fontSize: 60.0),
              //             )),
              //       ),
              //     ),
              //     Expanded(
              //         child: Card(
              //       child: ListTile(
              //           title: ElevatedButton.icon(onPressed: null, icon: const Icon(Icons.tag_faces), label: const Text("Brands")),
              //           subtitle: Text(
              //             storeController.brandList.length.toString(),
              //             textAlign: TextAlign.center,
              //             style: TextStyle(color: active, fontSize: 60.0),
              //           )),
              //     )),
              //   ],
              // ),
              Row(
                children: [
                  Expanded(
                      child: Card(
                    child: ListTile(
                      onTap: (){

                      },
                        title: ElevatedButton.icon(
                            onPressed: null, icon: const Icon(Icons.shopping_cart), label: const Text("Orders")),
                        subtitle: Text(
                          '5',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  )),
                  Expanded(
                      child: Card(
                    child: ListTile(
                        title: ElevatedButton.icon(onPressed: null, icon: const Icon(Icons.close), label: const Text("Return")),
                        subtitle: Text(
                          '0',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        )),
                  )),
                ],
              ),

              Row(
                children: [
                  Expanded(
                      child: Card(
                        child: ListTile(
                            title: ElevatedButton.icon(onPressed: null, icon: const Icon(Icons.tag_faces), label: const Text("Sold")),
                            subtitle: Text(
                              '13',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: active, fontSize: 60.0),
                            )),
                      )),
                ],
              )
            ],
          ),
        )),
      ],
    ));
  }
}
