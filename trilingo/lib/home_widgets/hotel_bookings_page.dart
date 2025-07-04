import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:trilingo/ui/widgets/spacethemeui.dart';

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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.cyanAccent,
            onPrimary: Colors.black,
            surface: Colors.grey[900]!,
            onSurface: Colors.cyanAccent,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.cyanAccent),
          ),
        ),
        child: child!,
      ),
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
    final imageUrl = hotel['images']?.isNotEmpty == true
        ? 'https://${hotel['images'][0]['path']}'
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 16),
              Text(hotel['name'] ?? 'Unnamed',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      fontFamily: 'Orbitron')),
              SizedBox(height: 8),
              Text('Category: ${hotel['categoryCode'] ?? "N/A"}',
                  style: TextStyle(color: Colors.white70)),
              Text('Zone: ${hotel['zoneName'] ?? "Unknown"}',
                  style: TextStyle(color: Colors.white70)),
              Text('Price: \$${hotel['minRate'] ?? "--"}',
                  style: TextStyle(color: Colors.greenAccent)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  child: Text('Book', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchHotels() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.cyanAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const AnimatedSpaceBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInputCard(),
                  SizedBox(height: 12),
                  Expanded(child: _buildHotelResults()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.8),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (val) => destination = val.toLowerCase(),
            style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron'),
            decoration: InputDecoration(
              hintText: 'Enter destination (e.g., Tokyo)',
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Orbitron'),
              prefixIcon: Icon(Icons.location_on, color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: Colors.white, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.cyanAccent, width: 3),
              ),
            ),
          ),
          SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNumberSelector(
                label: 'Adults',
                value: adultsCount,
                min: 1,
                onDecrement: () => setState(() {
                  if (adultsCount > 1) adultsCount--;
                }),
                onIncrement: () => setState(() => adultsCount++),
              ),
              _buildNumberSelector(
                label: 'Children',
                value: childrenCount,
                min: 0,
                onDecrement: () => setState(() {
                  if (childrenCount > 0) childrenCount--;
                }),
                onIncrement: () => setState(() => childrenCount++),
              ),
            ],
          ),
          SizedBox(height: 22),
          ElevatedButton(
            onPressed: _selectDateRange,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 15,
              shadowColor: Colors.cyanAccent.withOpacity(0.9),
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 50),
            ),
            child: Text(
              checkInDate != null && checkOutDate != null
                  ? 'Selected: ${_formatDate(checkInDate!)} → ${_formatDate(checkOutDate!)}'
                  : 'Select Dates',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: isLoading ? null : _searchHotels,
            icon: Icon(Icons.search),
            label: Text('Search Hotels', style: TextStyle(fontFamily: 'Orbitron')),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 10,
              shadowColor: Colors.deepPurpleAccent.withOpacity(0.8),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 90),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberSelector({
    required String label,
    required int value,
    required int min,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.8), width: 2),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: Colors.redAccent),
                onPressed: value > min ? onDecrement : null,
              ),
              Text(
                value.toString(),
                style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.greenAccent),
                onPressed: onIncrement,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHotelResults() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.cyanAccent,
          strokeWidth: 4,
        ),
      );
    }
    if (hotels.isEmpty) {
      return Center(
        child: Text(
          'No results',
          style: TextStyle(
            color: Colors.cyanAccent.withOpacity(0.5),
            fontSize: 20,
            fontFamily: 'Orbitron',
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        final imageUrl = (hotel['images']?.isNotEmpty == true)
            ? 'https://${hotel['images'][0]['path']}'
            : null;
        return GestureDetector(
          onTap: () => _openHotelDetails(hotel),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.cyanAccent, width: 2),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.07),
                  Colors.cyanAccent.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              leading: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                    )
                  : Icon(Icons.hotel, color: Colors.cyanAccent),
              title: Text(
                hotel['name'] ?? 'Unnamed Hotel',
                style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron'),
              ),
              subtitle: Text(
                hotel['zoneName'] ?? 'Unknown Zone',
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                '\$${hotel['minRate'] ?? '--'}',
                style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}


class HotelApiService {
  static const apiKey = 'ccd37e61d6b6b205c736e05cc670b7e9';
  static const secret = '269fadc249';

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
