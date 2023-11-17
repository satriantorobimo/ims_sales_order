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

class ApplicationForm1TabScreen extends StatefulWidget {
  const ApplicationForm1TabScreen({super.key});

  @override
  State<ApplicationForm1TabScreen> createState() =>
      _ApplicationForm1TabScreenState();
}

class _ApplicationForm1TabScreenState extends State<ApplicationForm1TabScreen> {
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
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 32.0, left: 24, right: 24),
                  child: Text(
                    'Province',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
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
                          left: 24, right: 24, bottom: 24),
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
                  padding: EdgeInsets.only(top: 32.0, left: 24, right: 24),
                  child: Text(
                    'City',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
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
                          left: 24, right: 24, bottom: 24),
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
                  padding: EdgeInsets.only(top: 32.0, left: 24, right: 24),
                  child: Text(
                    'Postal',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
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
                          left: 24, right: 24, bottom: 24),
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
            'Application Form',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: Colors.white,
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFFFD174),
                                        width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFFD174)),
                                    child: const Icon(
                                      Icons.warning_amber_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFFFD174),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Client',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFDCDCDC),
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFDCDCDC)),
                                  child: const Center(
                                    child: Text(
                                      '2',
                                      style: TextStyle(
                                          color: Color(0xFF444444),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFDCDCDC),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Loan Data',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFDCDCDC),
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFDCDCDC)),
                                  child: const Center(
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                          color: Color(0xFF444444),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFDCDCDC),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Asset',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFDCDCDC),
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFDCDCDC)),
                                  child: const Center(
                                    child: Text(
                                      '4',
                                      style: TextStyle(
                                          color: Color(0xFF444444),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFDCDCDC),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'T&C',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 3,
                                color: const Color(0xFFDCDCDC),
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFDCDCDC)),
                                  child: const Center(
                                    child: Text(
                                      '5',
                                      style: TextStyle(
                                          color: Color(0xFF444444),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 3,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Document',
                            style: TextStyle(
                                color: Color(0xFF444444),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 22.0, right: 20.0, top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '1. ID No',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'ID NO',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        '2. Full Name',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Full Name',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '3. Place of Birth',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Place of Birth',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '4. Date of Birth',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Date of Birth',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        '5. Mother Maiden Name',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Mother Maiden Name',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '6. Gender',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                    height: 52,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              gender = 'Male';
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: gender == 'Male'
                                                  ? primaryColor
                                                  : const Color(0xFFE1E1E1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                                child: Text('Male',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600))),
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
                                            height: 40,
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: gender == 'Female'
                                                  ? primaryColor
                                                  : const Color(0xFFE1E1E1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Center(
                                                child: Text('Female',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '7. Email',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Email',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '8. Phone No',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                    width: 280,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Material(
                                          elevation: 6,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 90,
                                            height: 50,
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Code',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Material(
                                          elevation: 6,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 180,
                                            height: 50,
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'Phone Number',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '9. Marital Status',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                        shadowColor:
                                            Colors.grey.withOpacity(0.4),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                                width: 1.0,
                                                color: Color(0xFFEAEAEA))),
                                        child: SizedBox(
                                          width: 280,
                                          height: 50,
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: 'Marital Status',
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        16.0, 20.0, 20.0, 16.0),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '10. Spouse Name',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Spouse Name',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '11. Spouse ID',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Spouse Name ID',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                            ],
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '12. Province',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                          width: 280,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.1)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                blurRadius: 6,
                                                offset: const Offset(
                                                    -6, 4), // Shadow position
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              selectProv == ''
                                                  ? 'Province'
                                                  : selectProv,
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '13. City',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                          width: 280,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.1)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                blurRadius: 6,
                                                offset: const Offset(
                                                    -6, 4), // Shadow position
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              selectCity == ''
                                                  ? 'City'
                                                  : selectCity,
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '14. Zipcode',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                          width: 280,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.1)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                blurRadius: 6,
                                                offset: const Offset(
                                                    -6, 4), // Shadow position
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 16.0, right: 16.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              selectPostal == ''
                                                  ? 'Zipcode'
                                                  : selectPostal,
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '15. Sub District',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Sub District',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '16. Village',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Village',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                            ],
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '17. Address',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 151,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        maxLines: 6,
                                        decoration: InputDecoration(
                                            hintText: 'Address',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '18. RT / RW',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
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
                                    width: 280,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Material(
                                          elevation: 6,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 130,
                                            height: 50,
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'RT',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Material(
                                          elevation: 6,
                                          shadowColor:
                                              Colors.grey.withOpacity(0.4),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFEAEAEA))),
                                          child: SizedBox(
                                            width: 130,
                                            height: 50,
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: 'RW',
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16.0,
                                                          20.0,
                                                          20.0,
                                                          16.0),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                              const SizedBox(height: 20),
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
                                      width: 188,
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
                                                  fontWeight:
                                                      FontWeight.w600))),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Material(
                                    elevation: 6,
                                    shadowColor: Colors.grey.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            width: 1.0,
                                            color: Color(0xFFEAEAEA))),
                                    child: SizedBox(
                                      width: 280,
                                      height: 50,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: '-',
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    16.0, 20.0, 20.0, 16.0),
                                            hintStyle: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
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
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 200,
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
                        Navigator.pushNamed(context,
                            StringRouterUtil.applicationForm2ScreenTabRoute);
                      },
                      child: Container(
                        width: 200,
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
        ));
  }
}
