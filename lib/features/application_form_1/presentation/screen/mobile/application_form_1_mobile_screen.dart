import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_order/features/application_form_1/data/city_model.dart'
    as city;
import 'package:sales_order/features/application_form_1/data/province_model.dart'
    as province;
import 'package:sales_order/features/application_form_1/data/postal_model.dart'
    as postal;
import 'package:sales_order/utility/color_util.dart';
import 'package:sales_order/utility/string_router_util.dart';

class ApplicationForm1MobileScreen extends StatefulWidget {
  const ApplicationForm1MobileScreen({super.key});

  @override
  State<ApplicationForm1MobileScreen> createState() =>
      _ApplicationForm1MobileScreenState();
}

class _ApplicationForm1MobileScreenState
    extends State<ApplicationForm1MobileScreen> {
  String gender = 'Male';
  String selectProv = '';
  int selectIndexProv = 0;
  String selectCity = '';
  int selectIndexCity = 0;
  String selectPostal = '';
  int selectIndexPostal = 0;
  List<province.Data> provinces = [];
  List<city.Data> cities = [];
  List<city.Data> filterCities = [];
  List<postal.Data> postals = [];
  List<postal.Data> filterPostals = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    var dataProv = await rootBundle.loadString('assets/data/province.json');
    var dataCity = await rootBundle.loadString('assets/data/city.json');
    var dataPostal = await rootBundle.loadString('assets/data/postal.json');
    var jsonResultProv = await json.decode(dataProv);
    var jsonResultCity = await json.decode(dataCity);
    var jsonResultPostal = await json.decode(dataPostal);
    jsonResultProv['data']
        .forEach((element) => provinces.add(province.Data.fromJson(element)));
    jsonResultCity['data']
        .forEach((element) => cities.add(city.Data.fromJson(element)));
    jsonResultPostal['data']
        .forEach((element) => postals.add(postal.Data.fromJson(element)));
    selectIndexProv = provinces.length + 1;
    selectIndexCity = cities.length + 1;
    selectIndexPostal = postals.length + 1;
  }

  Future<void> _showBottom() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                  child: Text(
                    'Province',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                            width: 1.0, color: Color(0xFFEAEAEA))),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Search',
                            isDense: true,
                            contentPadding: const EdgeInsets.all(24),
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.5)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      itemCount: provinces.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: Divider(),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (selectIndexProv == index) {
                                selectProv = '';
                                selectIndexProv = provinces.length + 1;
                              } else {
                                filterCities = cities
                                    .where((i) =>
                                        i.provinceId == provinces[index].id)
                                    .toList();
                                filterPostals = postals
                                    .where((i) =>
                                        i.provinceCode == provinces[index].id)
                                    .toList();
                                selectProv = provinces[index].name!;
                                selectIndexProv = index;
                                selectCity = '';
                                selectIndexCity = filterCities.length + 1;
                                selectPostal = '';
                                selectIndexPostal = filterPostals.length + 1;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                provinces[index].name!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              selectIndexProv == index
                                  ? const Icon(Icons.check_rounded,
                                      color: primaryColor)
                                  : Container()
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showBottomCity() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                  child: Text(
                    'City',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            width: 1.0, color: Color(0xFFEAEAEA))),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Search',
                            isDense: true,
                            contentPadding: const EdgeInsets.all(24),
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.5)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      itemCount: filterCities.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: Divider(),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (selectIndexCity == index) {
                                selectCity = '';
                                selectIndexCity = filterCities.length + 1;
                              } else {
                                selectCity = filterCities[index].name!;
                                selectIndexCity = index;
                                selectPostal = '';
                                selectIndexPostal = filterPostals.length + 1;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                filterCities[index].name!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              selectIndexCity == index
                                  ? const Icon(Icons.check_rounded,
                                      color: primaryColor)
                                  : Container()
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showBottomPostal() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 8, right: 8),
                  child: Text(
                    'Postal',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            width: 1.0, color: Color(0xFFEAEAEA))),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Search',
                            isDense: true,
                            contentPadding: const EdgeInsets.all(24),
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.5)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      itemCount: filterPostals.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: Divider(),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (selectIndexPostal == index) {
                                selectPostal = '';
                                selectIndexPostal = filterPostals.length + 1;
                              } else {
                                selectPostal = filterPostals[index].postalCode!;
                                selectIndexPostal = index;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                filterPostals[index].postalCode!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              selectIndexPostal == index
                                  ? const Icon(Icons.check_rounded,
                                      color: primaryColor)
                                  : Container()
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text(
            'Client Data',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ID No',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'ID NO',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Full Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Full Name',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Place of Birth',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Place of Birth',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Date of Birth',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Date of Birth',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          '7. Mother Maiden Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Mother Maiden Name',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Gender',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                gender = 'Male';
                              });
                            },
                            child: Container(
                              height: 38,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: gender == 'Male'
                                    ? primaryColor
                                    : const Color(0xFFE1E1E1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                  child: Text('Male',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              setState(() {
                                gender = 'Female';
                              });
                            },
                            child: Container(
                              height: 38,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: gender == 'Female'
                                    ? primaryColor
                                    : const Color(0xFFE1E1E1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                  child: Text('Female',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Email',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Phone No',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                elevation: 6,
                                shadowColor: Colors.grey.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        width: 1.0, color: Color(0xFFEAEAEA))),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 45,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Code',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                ),
                              ),
                              Material(
                                elevation: 6,
                                shadowColor: Colors.grey.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        width: 1.0, color: Color(0xFFEAEAEA))),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 45,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Phone Number',
                                        isDense: true,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Marital Status',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: const Alignment(0, 0),
                      children: [
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Marital Status',
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 16,
                          child: GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF3D3D3D),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Spouse Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Spouse Name',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Spouse ID',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Spouse Name ID',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Province',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: const Alignment(0, 0),
                      children: [
                        InkWell(
                          onTap: _showBottom,
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.1)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ],
                            ),
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                selectProv == '' ? 'Province' : selectProv,
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 16,
                          child: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF3D3D3D),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'City',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: const Alignment(0, 0),
                      children: [
                        InkWell(
                          onTap: _showBottomCity,
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.1)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ],
                            ),
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                selectCity == '' ? 'City' : selectCity,
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 16,
                          child: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF3D3D3D),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Zipcode',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      alignment: const Alignment(0, 0),
                      children: [
                        InkWell(
                          onTap: _showBottomPostal,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.1)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ],
                            ),
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                selectPostal == '' ? 'Zipcode' : selectPostal,
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 16,
                          child: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF3D3D3D),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Sub District',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'Sub District',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Village',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'Village',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Address',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 135,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: 'Address',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'RT / RW',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' *',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Material(
                            elevation: 6,
                            shadowColor: Colors.grey.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    width: 1.0, color: Color(0xFFEAEAEA))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 45,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: 'RT',
                                    isDense: true,
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.5)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Material(
                            elevation: 6,
                            shadowColor: Colors.grey.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    width: 1.0, color: Color(0xFFEAEAEA))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 45,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: 'RW',
                                    isDense: true,
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.5)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 53,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Text('Check Scoring',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 6,
                      shadowColor: Colors.grey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                              width: 1.0, color: Color(0xFFEAEAEA))),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: '-',
                              isDense: true,
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                              child: Text('PREV',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600))),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              StringRouterUtil
                                  .applicationForm2ScreenMobileRoute);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: thirdColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                              child: Text('NEXT',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
