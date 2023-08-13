import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlightDetail {
  final String origin;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final bool hasLayover;
  final String layoverDuration;

  FlightDetail({
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.hasLayover,
    this.layoverDuration = '',
  });

  factory FlightDetail.fromJson(Map<String, dynamic> json) {
    return FlightDetail(
      origin: json['originLocationCode'] ?? '',
      destination: json['destinationLocationCode'] ?? '',
      departureTime: json['departureDate'] ?? '',
      arrivalTime: json['arrivalDate'] ?? '',
      hasLayover: json['nonStop'] ?? false,
      layoverDuration: json['flightStops'] ?? '',
    );
  }
}

class FlightResultsPage extends StatelessWidget {
  final List<FlightDetail> flights;

  FlightResultsPage({required this.flights});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Search Results'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: ListView.builder(
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlightDetailsPage(flight: flight),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.flight,
                    size: 40,
                    color: Colors.blue,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Origin: ${flight.origin}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Destination: ${flight.destination}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Departure Time: ${flight.departureTime}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Arrival Time: ${flight.arrivalTime}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          flight.hasLayover
                              ? 'Layover Duration: ${flight.layoverDuration}'
                              : 'Direct Flight',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FlightDetailsPage extends StatelessWidget {
  final FlightDetail flight;

  FlightDetailsPage({required this.flight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Details'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Origin: ${flight.origin}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Destination: ${flight.destination}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Departure Time: ${flight.departureTime}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Arrival Time: ${flight.arrivalTime}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              flight.hasLayover
                  ? 'Layover Duration: ${flight.layoverDuration}'
                  : 'Direct Flight',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FlightResultsPage(
      flights: [
        // Add your FlightDetail objects here
      ],
    ),
  ));
}

class FlightBookingsPage extends StatefulWidget {
  @override
  _FlightBookingsPageState createState() => _FlightBookingsPageState();
}

class _FlightBookingsPageState extends State<FlightBookingsPage> {
  String selectedDestination = 'BOM';
  String selectedArrival = 'DXB';
  bool isOneWay = true;
  bool isRoundTrip = false;
  int adultsCount = 1;
  int childsCount = 0;

  DateTime? departureDate;
  DateTime? returnDate;
  List<FlightDetail> flightResults = [];

  Future<void> searchFlights() async {
    final String apiKey = '';
    final String apiUrl =
        'https://test.api.amadeus.com/v2/shopping/flight-offers';

    final headers = {
      'Authorization': 'Bearer $apiKey',
    };

    final queryParams = {
      'originLocationCode': 'JFK',
      'destinationLocationCode': selectedDestination,
      'departureDate': departureDate != null
          ? departureDate!.toIso8601String().split('T')[0]
          : '',
      'returnDate':
          returnDate != null ? returnDate!.toIso8601String().split('T')[0] : '',
      'adults': adultsCount.toString(),
      // ... other parameters ...
    };

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final flightsData = jsonResponse['data'] as List<dynamic>;

      final flights = flightsData
          .map((flightData) => FlightDetail.fromJson(flightData))
          .toList();
      print('Parsed Flights: $flights');

      setState(() {
        flightResults = flights;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlightResultsPage(flights: flightResults),
        ),
      );
    } else {
      print('API request failed with status code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Bookings'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            Text(
              'Search Flights',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedDestination,
                    onChanged: (value) {
                      setState(() {
                        selectedDestination = value!;
                      });
                    },
                    items: ['JFK', 'BOM', 'DXB']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration:
                        InputDecoration(labelText: 'Select Destination'),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedArrival,
                    onChanged: (value) {
                      setState(() {
                        selectedArrival = value!;
                      });
                    },
                    items: ['JFK', 'BOM', 'DXB']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Select Arrival'),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isOneWay,
                        onChanged: (value) {
                          setState(() {
                            isOneWay = value!;
                            if (isOneWay) {
                              isRoundTrip = false;
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Text(
                        'One way trip',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 16),
                      Checkbox(
                        value: isRoundTrip,
                        onChanged: (value) {
                          setState(() {
                            isRoundTrip = value!;
                            if (isRoundTrip) {
                              isOneWay = false;
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Text(
                        'Round trip',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  if (isOneWay || isRoundTrip)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text('Departure Date'),
                        InkWell(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                departureDate = selectedDate;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                departureDate != null
                                    ? '${departureDate!.day}/${departureDate!.month}/${departureDate!.year}'
                                    : 'Select Date',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (isRoundTrip)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text('Return Date'),
                        InkWell(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: departureDate ?? DateTime.now(),
                              firstDate: departureDate ?? DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                returnDate = selectedDate;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                returnDate != null
                                    ? '${returnDate!.day}/${returnDate!.month}/${returnDate!.year}'
                                    : 'Select Date',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Adults: '),
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Children: '),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (childsCount > 0) {
                              childsCount--;
                            }
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('$childsCount'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            childsCount++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: searchFlights,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Search Flights',
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
          ],
        ),
      ),
    );
  }
}
