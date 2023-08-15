import 'package:flutter/material.dart';

class HotelBookingsPage extends StatefulWidget {
  @override
  _HotelBookingsPageState createState() => _HotelBookingsPageState();
}

class _HotelBookingsPageState extends State<HotelBookingsPage> {
  int adultsCount = 1;
  int childrenCount = 0;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Bookings'),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0, // Match the app bar color from the homepage
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC2E2FF), Color(0xFFC2E2FF)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
              decoration: BoxDecoration(
                color: Color(0xFF1976D2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search Hotels',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter destination',
                      prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Perform search action
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book a Hotel',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Adults', style: TextStyle(color: Colors.black)),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (adultsCount > 1) {
                                    adultsCount--;
                                  }
                                });
                              },
                              icon: Icon(Icons.remove),
                              color: Colors.red,
                            ),
                            Text('$adultsCount',
                                style: TextStyle(color: Colors.black)),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  adultsCount++;
                                });
                              },
                              icon: Icon(Icons.add),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Children', style: TextStyle(color: Colors.black)),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (childrenCount > 0) {
                                    childrenCount--;
                                  }
                                });
                              },
                              icon: Icon(Icons.remove),
                              color: Colors.red,
                            ),
                            Text('$childrenCount',
                                style: TextStyle(color: Colors.black)),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  childrenCount++;
                                });
                              },
                              icon: Icon(Icons.add),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDates = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );

                        if (selectedDates != null) {
                          setState(() {
                            checkInDate = selectedDates.start;
                            checkOutDate = selectedDates.end;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Select Dates',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (checkInDate != null && checkOutDate != null) ...[
                      SizedBox(height: 16),
                      Text(
                        'Check-In: ${checkInDate!.toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        'Check-Out: ${checkOutDate!.toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Implement hotel booking logic here
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Search Hotels',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HotelBookingsPage(),
  ));
}
