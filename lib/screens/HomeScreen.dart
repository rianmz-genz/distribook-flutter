import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:distribook/components/AnnouncementListHome.dart';
import 'package:distribook/components/CardHomePage.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:distribook/helpers/index.dart';
import 'package:distribook/screens/AllAnnouncementScreen.dart';
import 'package:distribook/screens/AttendanceScreen.dart';
import 'package:distribook/screens/NextVersionFeatureScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> cardListBelow = [
      {
        'icon': 'assets/icons/hrm_reimbursement.svg',
        'iconColor': Colors.green,
        'title': 'Reimbursement',
        'onTap': () {
          navigateTo(context, NextVersionFeatureScreen());
        },
      },
      {
        'icon': 'assets/icons/hrm_payslip.svg',
        'iconColor': const Color(0xFF077091),
        'title': 'My PaySlip',
        'onTap': () async {
          navigateTo(context, NextVersionFeatureScreen());
        },
      },
      {
        'icon': 'assets/icons/hrm_calendar.svg',
        'iconColor': const Color(0xFF846A28),
        'title': 'Calendar',
        'onTap': () {
          navigateTo(context, NextVersionFeatureScreen());
        },
      },
      {
        'icon': 'assets/icons/hrm_timeoff.svg',
        'iconColor': const Color(0xFF842828),
        'title': 'Time Off',
        'onTap': () {
          navigateTo(context, NextVersionFeatureScreen());
        },
      },
      {
        'icon': 'assets/icons/hrm_liveattendance.svg',
        'iconColor': const Color.fromARGB(255, 225, 149, 8),
        'title': 'Live Attandance',
        'onTap': () {
          navigateTo(context, AttendanceScreen());
        },
      },
      {
        'icon': 'assets/icons/hrm_attendancelog.svg',
        'iconColor': const Color(0xFF282C84),
        'title': 'Attandance Log',
        'onTap': () {
          navigateTo(context, NextVersionFeatureScreen());
        },
      },
    ];
    List<dynamic> cardList = [
      {
        'icon': 'assets/icons/hrm_reimbursement.svg',
        'title': 'Reimbursement',
        'onTap': () {
          navigateTo(context, NextVersionFeatureScreen());
        },
      },
      {
        'icon': 'assets/icons/hrm_liveattendance.svg',
        'title': 'Attendance',
        'onTap': () {
          navigateTo(context, AttendanceScreen());
        },
      },
      {
        'icon': 'assets/icons/hrm_timeoff.svg',
        'title': 'Time Off',
        'onTap': () {
          navigateTo(context, NextVersionFeatureScreen());
        },
      },
    ];
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Header
          CardHomePage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text("Recently", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 70.0,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: cardList.length,
              itemBuilder: (BuildContext context, int index) => Card(
                color: Color(0XFFF3F4F6),
                elevation: 0,
                child: InkWell(
                  onTap: cardList[index]['onTap'],
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(left: 8),
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset(
                          cardList[index]['icon'],
                          color: Color(0xff609966),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Request',
                              maxLines: 1,
                            ),
                            Text(
                              cardList[index]['title'],
                              maxLines: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          ResponsiveGridList(
            minItemsPerRow:
                3, // The minimum items to show in a single row. Takes precedence over minItemWidth
            maxItemsPerRow:
                6, // The maximum items to show in a single row. Can be useful on large screens
            minItemWidth: MediaQuery.of(context).size.width / 2.2,
            listViewBuilderOptions: ListViewBuilderOptions(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true),
            children: cardListBelow
                .map(
                  (e) => Card(
                    elevation: 0,
                    color: Colors.white,
                    child: InkWell(
                      onTap: e['onTap'],
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: e['iconColor'],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              e['icon'],
                            ),
                          ),
                          Text(
                            e['title'],
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 24),
          // Announcement
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text("Announcement",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                InkWell(
                    onTap: () {
                      navigateTo(context, AllAnnouncementScreen());
                    },
                    child:
                        Text("View All", style: TextStyle(color: Colors.blue))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AnnouncementList(
            height: 300,
            limit: 3,
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _mainMenu(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
