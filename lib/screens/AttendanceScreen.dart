import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:intl/intl.dart';
import 'package:distribook/api/impl/attendance.dart';
import 'package:distribook/components/Navbar.dart';
import 'package:distribook/responses/get_today_attendance_response.dart';
import 'package:distribook/screens/TakeAttendanceScreen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLoading = true;
  TodayAttendanceResponse? todayAttendanceResponse;
  double latitude = 0.0;
  double longitude = 0.0;
  String locationLat = 'Tidak Ditemukan';
  String locationLong = 'Tidak Ditemukan';
  final Color primaryColor = Colors.green;
  final Color backgroundColor = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    performGetTodayAttendance();
  }

  String getTodayDate() {
    return DateFormat('dd MMMM yyyy').format(DateTime.now());
  }

  void performGetTodayAttendance() async {
    final result = await fetchTodayAttendance(context: context);
    setState(() {
      todayAttendanceResponse = result;
      isLoading = false;
    });
  }

  Future<void> getAddressFromLatLong(Position position, route) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    var alamatLokasi =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TakeAttendanceScreen(
          title: route,
          address: alamatLokasi,
        ),
      ),
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void cekLokasi(route) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Position position = await _getGeoLocationPosition();
    setState(() {
      locationLat = position.latitude.toString();
      latitude = position.latitude;
      longitude = position.longitude;
      locationLong = position.longitude.toString();
    });
    prefs.setString('lat', locationLat);
    prefs.setString('long', locationLong);

    getAddressFromLatLong(position, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => isLoading = true);
            performGetTodayAttendance();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Tombol Kembali Custom
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: primaryColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Navbar()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // ... lanjutkan konten
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      DigitalClock(
                        hourMinuteDigitTextStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        secondDigitTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        colon: Text(
                          ':',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        getTodayDate(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      isLoading
                          ? CircularProgressIndicator()
                          : Builder(
                              builder: (context) {
                                final checkIn =
                                    todayAttendanceResponse?.checkIn ?? '';
                                final checkOut =
                                    todayAttendanceResponse?.checkOut ?? '';

                                final isCheckInEmpty =
                                    checkIn == '-' || checkIn == 'No Check In';
                                final isCheckOutEmpty = checkOut == '-' ||
                                    checkOut == 'No Check Out';

                                if (isCheckInEmpty && isCheckOutEmpty) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildButton('Clock In', primaryColor,
                                          () {
                                        cekLokasi('Clock In');
                                      }),
                                      SizedBox(width: 12),
                                      _buildButton(
                                          'Clock Out', Colors.redAccent, () {
                                        cekLokasi('Clock Out');
                                      }),
                                    ],
                                  );
                                } else if (!isCheckInEmpty && isCheckOutEmpty) {
                                  return Center(
                                    child: _buildButton(
                                        'Clock Out', Colors.redAccent, () {
                                      cekLokasi('Clock Out');
                                    }),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? Column(
                        children: List.generate(
                          2,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Attendance",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          SizedBox(height: 10),
                          _buildInfoCard('Clock In:',
                              todayAttendanceResponse?.checkIn ?? '-'),
                          SizedBox(height: 10),
                          _buildInfoCard('Clock Out:',
                              todayAttendanceResponse?.checkOut ?? '-'),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: Size(140, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87),
            ),
            SizedBox(width: 12),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
