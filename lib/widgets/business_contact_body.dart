import 'package:mooweapp/export_files.dart';

class BusinessContactBody extends StatelessWidget {
  Business business;
  BusinessContactBody({Key? key, required this.business}) : super(key: key);
  // var con_serv = locator.get<ContactServices>();
  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), //or 15.0
        child: Container(
          height: 70.0,
          width: 70.0,
          color: kPrimaryColor,
          child: storage.networkImage(business.creditCard!.imageUrl, shape: BoxShape.rectangle, fit: BoxFit.cover),
        ),
      ),
      title: Text(
        "${business.businessName}",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey[900],
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${business.address} ${business.city}"),
          Text("${business.state} ${business.zip}"),
          // Text(" ${business.phone}"),
        ],
      ),
    );
  }
}
