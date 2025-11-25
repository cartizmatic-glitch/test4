import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Order System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CustomerOrderScreen(),
    );
  }
}

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key});

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  final TextEditingController _controller = TextEditingController();
  String _customerName = '';
  String _welcomeMessage = '';
  List<Map<String, dynamic>> _customerOrders = [];
  List<Map<String, dynamic>> _customerAllocations = [];

  // دیتابیس مشتریان
  final Map<String, String> _customers = {
    '6506866613': 'ایران خودرو',
    '6570132092': 'سایپا',
    // ... بقیه مشتریان (همان قبلی)
    '1111111111': 'الکس 1',
    '2222222222': 'الکس 2',
  };

  // دیتابیس سفارشات
  final List<Map<String, dynamic>> _orders = [
    {
      'OrderID': '33452878',
      'OrderDate': '14040401',
      'CustomerID': '3685990370',
      'Currency': 'USD',
      'Amount': 304959,
    },
    {
      'OrderID': '13725630',
      'OrderDate': '14040423',
      'CustomerID': '9922196660',
      'Currency': 'EUR',
      'Amount': 12966,
    },
    {
      'OrderID': '56086913',
      'OrderDate': '14040811',
      'CustomerID': '7687349089',
      'Currency': 'CNY',
      'Amount': 52930,
    },
    {
      'OrderID': '88888888',
      'OrderDate': '14040901',
      'CustomerID': '1111111111',
      'Currency': 'USD',
      'Amount': 10000,
    },
    {
      'OrderID': '77777777',
      'OrderDate': '14040902',
      'CustomerID': '1111111111',
      'Currency': 'EUR',
      'Amount': 10000,
    },
    {
      'OrderID': '66666666',
      'OrderDate': '14040202',
      'CustomerID': '1111111111',
      'Currency': 'EUR',
      'Amount': 200,
    },
    {
      'OrderID': '99999999',
      'OrderDate': '14040502',
      'CustomerID': '1111111111',
      'Currency': 'EUR',
      'Amount': 3000,
    },
    {
      'OrderID': '55555555',
      'OrderDate': '14040302',
      'CustomerID': '2222222222',
      'Currency': 'EUR',
      'Amount': 100,
    },
    // ... بقیه سفارشات
  ];

  // دیتابیس تخصیص‌ها
  final List<Map<String, dynamic>> _allocations = [
    {'Date': '14040903', 'Reg_No': '33452878', 'Rate': 820000},
    {'Date': '14040903', 'Reg_No': '52946370', 'Rate': 820000},
    {'Date': '14040903', 'Reg_No': '88888888', 'Rate': 820000},
    {'Date': '14040904', 'Reg_No': '77777777', 'Rate': 930000},
    {'Date': '14040904', 'Reg_No': '66666666', 'Rate': 930000},
    // ... بقیه تخصیص‌ها
  ];

  void _findCustomer() {
    String input = _controller.text;
    setState(() {
      _customerName = _customers[input] ?? 'مشتری نامعتبر';
      _welcomeMessage = _customerName != 'مشتری نامعتبر'
          ? 'خوش آمدید $_customerName'
          : 'شماره مشتری یافت نشد';

      // پیدا کردن سفارشات مشتری
      _customerOrders = _orders
          .where((order) => order['CustomerID'] == input)
          .toList();

      // پیدا کردن تخصیص‌های مربوط به سفارشات این مشتری
      _customerAllocations = _allocations.where((alloc) {
        return _customerOrders.any(
          (order) => order['OrderID'] == alloc['Reg_No'],
        );
      }).toList();
    });
  }

  // تابع برای پیدا کردن تخصیص یک سفارش
  Map<String, dynamic>? _findAllocation(String orderId) {
    return _customerAllocations.firstWhere(
      (alloc) => alloc['Reg_No'] == orderId,
      orElse: () => {},
    );
  }

  // تابع برای فرمت کردن تاریخ
  String _formatDate(String date) {
    if (date.length == 8) {
      return '${date.substring(0, 4)}/${date.substring(4, 6)}/${date.substring(6, 8)}';
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سیستم مشتریان و سفارشات'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // فیلد جستجو
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'شماره مشتری را وارد کنید',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _findCustomer,
                  child: const Text('جستجو'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // نمایش پیام خوش آمدگویی
            if (_welcomeMessage.isNotEmpty)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _welcomeMessage,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // نمایش آمار
            if (_customerOrders.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${_customerOrders.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text('تعداد سفارشات'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${_customerAllocations.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const Text('سفارشات تخصیص یافته'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // لیست سفارشات
            if (_customerOrders.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _customerOrders.length,
                  itemBuilder: (context, index) {
                    final order = _customerOrders[index];
                    final allocation = _findAllocation(order['OrderID']);
                    final hasAllocation =
                        allocation != null && allocation.isNotEmpty;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: hasAllocation
                          ? Colors.green[50]
                          : Colors.orange[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'سفارش ${order['OrderID']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: hasAllocation
                                        ? Colors.green
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    hasAllocation
                                        ? 'تخصیص یافته'
                                        : 'در صف تخصیص',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  'تاریخ ثبت: ${_formatDate(order['OrderDate'])}',
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                const Icon(Icons.attach_money, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  'مبلغ: ${order['Amount']} ${order['Currency']}',
                                ),
                              ],
                            ),

                            if (hasAllocation) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'تاریخ تخصیص: ${_formatDate(allocation['Date'])}',
                                    ),
                                    const SizedBox(width: 10),
                                    Text('نرخ: ${allocation['Rate']}'),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // پیام وقتی سفارشی وجود ندارد
            if (_customerName.isNotEmpty && _customerOrders.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'هیچ سفارشی برای این مشتری یافت نشد',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
