import 'package:flutter/material.dart';

class ConsultationScreen extends StatelessWidget {
  final List<String> patients = [
    'Marvel Ravindra Dioputra',
    'Indra Aldi',
    'Berliana Ramadhani'
  ];
  final List<String> paymentMethods = ['Transfer Bank', 'OVO', 'GoPay'];
  final List<String> doctors = [
    'Dr. Sarah',
    'Dr. Tirta',
    'Dr. Farhan',
    'Dr. Andini'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Online Consultation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'I’m having headache',
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Consultation Method (10 minutes)*',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                    child: Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoCallScreen()),
                      );
                    },
                    child: Text(
                      'Video Call',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Choose Patient*',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pilih Pasien',
                ),
                items: patients.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // Handle dropdown value changes
                },
                onSaved: (String? value) {
                  // Handle saving dropdown value
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Choose Doctor*',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pilih Dokter',
                ),
                items: doctors.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // Handle dropdown value changes
                },
                onSaved: (String? value) {
                  // Handle saving dropdown value
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Choose Payment Method*',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pilih Metode Pembayaran',
                ),
                items: paymentMethods.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // Handle dropdown value changes
                },
                onSaved: (String? value) {
                  // Handle saving dropdown value
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text('Consultation Fee: Rp 40.000'),
                    SizedBox(height: 8.0),
                    Text('Video Call: Rp 10.000'),
                    SizedBox(height: 8.0),
                    Text('Total : Rp 50.000'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Konfirmasi Pembayaran'),
                          content: Text(
                              'Apakah Anda yakin ingin melakukan pembayaran sekarang?'),
                          actions: [
                            TextButton(
                              child: Text('Batal'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Ya, Bayar Sekarang'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentSuccessScreen()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Pay Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Doctor'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage(
                      'assets/doctor_profile.jpg'), // Ganti dengan path foto dokter Anda
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Sarah',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Spesialis Neurologi',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                Message message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message.type == MessageType.sender
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: message.type == MessageType.sender
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.type == MessageType.sender
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _messages.add(Message(
                            text: _controller.text, type: MessageType.sender));
                        _controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final MessageType type;

  Message({required this.text, required this.type});
}

enum MessageType {
  sender,
  receiver,
}

class VideoCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video feed background
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: Center(
                child: Text(
                  'Video Call',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ),
          // Call controls
          Positioned(
            bottom: 24.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Mute audio
                  },
                  child: Icon(Icons.mic_off),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                FloatingActionButton(
                  onPressed: () {
                    // End call
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.call_end),
                  backgroundColor: Colors.red,
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Switch camera
                  },
                  child: Icon(Icons.switch_camera),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'Payment Successfully Completed!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
