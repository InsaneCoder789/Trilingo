import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class HotelBookingsPage extends StatefulWidget {
  @override
  _HotelBookingsPageState createState() => _HotelBookingsPageState();
}

class _HotelBookingsPageState extends State<HotelBookingsPage> {
  int adultsCount = 1;
  int childrenCount = 0;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  String destination = '';

  List<dynamic> hotels = [];
  bool isLoading = false;

  Future<void> _selectDateRange() async {
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
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _openHotelDetails(dynamic hotel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final imageUrl = hotel['images']?.isNotEmpty == true
            ? 'https://${hotel['images'][0]['path']}'
            : null;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
              SizedBox(height: 12),
              Text(hotel['name'] ?? 'Unnamed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Category: ${hotel['categoryCode']}'),
              Text('Zone: ${hotel['zoneName']}'),
              Text('Price: \$${hotel['minRate'] ?? '--'}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Book'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Hotel Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text('Search Hotels',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (val) => destination = val.toLowerCase(),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter destination (e.g., London)',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Adults', style: TextStyle(color: Colors.white)),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white),
                                  onPressed: adultsCount > 1
                                      ? () => setState(() => adultsCount--)
                                      : null,
                                ),
                                Text('$adultsCount', style: TextStyle(color: Colors.white)),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () => setState(() => adultsCount++),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Children', style: TextStyle(color: Colors.white)),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white),
                                  onPressed: childrenCount > 0
                                      ? () => setState(() => childrenCount--)
                                      : null,
                                ),
                                Text('$childrenCount', style: TextStyle(color: Colors.white)),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () => setState(() => childrenCount++),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _selectDateRange,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Select Dates'),
                  ),
                  if (checkInDate != null && checkOutDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Selected: ${_formatDate(checkInDate!)} → ${_formatDate(checkOutDate!)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (destination.isEmpty || checkInDate == null || checkOutDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      final result = await HotelApiService.searchHotels(
                        destination: destination,
                        checkIn: checkInDate!,
                        checkOut: checkOutDate!,
                        adults: adultsCount,
                        children: childrenCount,
                      );

                      setState(() {
                        hotels = result;
                        isLoading = false;
                      });

                      if (hotels.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No hotels found or invalid destination.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 14, 56, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(Icons.search),
                    label: Text('Search'),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator(color: Colors.white))
                        : hotels.isEmpty
                            ? Center(child: Text('No results', style: TextStyle(color: Colors.white)))
                            : ListView.builder(
                                itemCount: hotels.length,
                                itemBuilder: (context, index) {
                                  final hotel = hotels[index];
                                  final name = hotel['name'] ?? 'Unnamed';
                                  final category = hotel['categoryCode'] ?? 'Unrated';
                                  final zone = hotel['zoneName'] ?? 'Unknown Zone';
                                  final price = hotel['minRate'] ?? '--';
                                  final imageUrl = hotel['images']?.isNotEmpty == true
                                      ? 'https://${hotel['images'][0]['path']}'
                                      : null;

                                  return GestureDetector(
                                    onTap: () => _openHotelDetails(hotel),
                                    child: Card(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            if (imageUrl != null)
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                                              )
                                            else
                                              Icon(Icons.hotel, size: 64, color: Colors.blueAccent),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                                                  SizedBox(height: 4),
                                                  Text('Category: $category • Area: $zone'),
                                                  Text('Price: \$${price}')
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HotelApiService {
  static const apiKey = '';
  static const secret = '';

  static const Map<String, String> destinationCodes = {
    'london': 'LON', 'paris': 'PAR', 'new york': 'NYC', 'dubai': 'DXB', 'tokyo': 'TYO',
    'mumbai': 'BOM', 'delhi': 'DEL', 'bangkok': 'BKK', 'sydney': 'SYD', 'berlin': 'BER',
    'rome': 'ROM', 'barcelona': 'BCN', 'singapore': 'SIN', 'amsterdam': 'AMS',
    'vienna': 'VIE', 'hong kong': 'HKG', 'los angeles': 'LAX', 'chicago': 'CHI',
    'toronto': 'YTO', 'moscow': 'MOW', 'istanbul': 'IST', 'cairo': 'CAI', 'seoul': 'SEL',
    'bali': 'DPS',
  };

  static Future<List<dynamic>> searchHotels({
    required String destination,
    required DateTime checkIn,
    required DateTime checkOut,
    required int adults,
    required int children,
  }) async {
    final code = destinationCodes[destination.toLowerCase()];
    if (code == null) return [];

    final headers = await _buildHeaders();
    final url = Uri.parse('https://api.test.hotelbeds.com/hotel-api/1.0/hotels');

    final List<int> childrenAges = List.generate(children, (_) => 8);

    final body = json.encode({
      "stay": {
        "checkIn": checkIn.toIso8601String().split('T')[0],
        "checkOut": checkOut.toIso8601String().split('T')[0],
      },
      "occupancies": [
        {
          "rooms": 1,
          "adults": adults,
          "children": children,
          "paxes": [
            ...List.generate(adults, (i) => {"type": "AD", "age": 30}),
            ...List.generate(children, (i) => {"type": "CH", "age": childrenAges[i]}),
          ]
        }
      ],
      "destination": {"code": code},
      "filter": {
        "maxHotels": 20,
      }
    });

    headers['Content-Type'] = 'application/json';

    try {
      final res = await http.post(url, headers: headers, body: body);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data['hotels']['hotels'] ?? [];
      } else {
        print('API Error: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

  static Future<Map<String, String>> _buildHeaders() async {
    final utcTime = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final signature = sha256.convert(utf8.encode(apiKey + secret + utcTime)).toString();
    return {
      'Api-Key': apiKey,
      'X-Signature': signature,
      'Accept': 'application/json',
    };
  }
}
