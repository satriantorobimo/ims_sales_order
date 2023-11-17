import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sales_order/features/home/data/notification_model.dart';

class NotificationTabWidget extends StatefulWidget {
  const NotificationTabWidget({super.key});

  @override
  State<NotificationTabWidget> createState() => _NotificationTabWidgetState();
}

class _NotificationTabWidgetState extends State<NotificationTabWidget> {
  late List<NotificationModel> data = [];

  @override
  void initState() {
    setState(() {
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 rejected',
          date: 'Just Now',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 approved',
          date: '59 minutes ago',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 cancel',
          date: '12 hours ago',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 hold',
          date: 'Today, 11:59',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Sorry we are under maintenance system',
          date: 'Yesterday',
          icon: 'maintenance'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 rejected',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 approved',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 cancel',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 hold',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Sorry we are under maintenance system',
          date: 'Yesterday',
          icon: 'maintenance'));
      data.add(NotificationModel(
          title: 'Sorry we are under maintenance system',
          date: 'Yesterday',
          icon: 'maintenance'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 rejected',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 approved',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 cancel',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 hold',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Sorry we are under maintenance system',
          date: 'Yesterday',
          icon: 'maintenance'));
      data.add(NotificationModel(
          title: 'Sorry we are under maintenance system',
          date: 'Yesterday',
          icon: 'maintenance'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 rejected',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 approved',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 cancel',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Application PSN.2013.00005 hold',
          date: 'Yesterday',
          icon: 'application'));
      data.add(NotificationModel(
          title: 'Sorry we are under maintenance system',
          date: 'Yesterday',
          icon: 'maintenance'));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0),
            child: Text(
              'Notification',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          data.isEmpty
              ? Container()
              : Expanded(
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 16);
                    },
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 32.0, top: 0, left: 16.0, right: 16.0),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 40,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 30,
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:  Color(data[index].icon == 'application' ? 0xFFE3F5FF : 0xFFE5ECF6), //E5ECF6
                                ),
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset(data[index].icon == 'application' ? 'assets/icon/application.svg' : 'assets/icon/maintenance.svg'),
                              ),
                            ],
                          ),
                          title: Text(
                            data[index].title,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text(
                            data[index].date,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      );
                    }),
              )
        ],
      ),
    );
  }
}
