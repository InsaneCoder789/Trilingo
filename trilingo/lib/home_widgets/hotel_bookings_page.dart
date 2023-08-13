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
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book a Hotel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Adults'),
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
                    ),
                    Text('$adultsCount'),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          adultsCount++;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Children'),
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
                    ),
                    Text('$childrenCount'),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          childrenCount++;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
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
              child: Text('Select Dates'),
            ),
            if (checkInDate != null && checkOutDate != null) ...[
              SizedBox(height: 16),
              Text(
                'Check-In: ${checkInDate!.toString().split(' ')[0]}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Check-Out: ${checkOutDate!.toString().split(' ')[0]}',
                style: TextStyle(fontSize: 16),
              ),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement hotel booking logic here
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Hotel Bookings App',
    home: HotelBookingsPage(),
  ));
}
