import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise/models/transaction.dart' as model;
import 'package:flutter/material.dart';
import 'package:rentwise/resources/transaction_methods.dart';
import 'package:rentwise/utils/colors.dart';
import 'package:rentwise/utils/utils.dart';
import 'package:rentwise/widgets/textfield_input.dart';

class TransactionSet extends StatefulWidget {
  const TransactionSet({super.key});

  @override
  State<TransactionSet> createState() => _TransactionSetState();
}

class _TransactionSetState extends State<TransactionSet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  model.TransactionReceiver? _selectedDestination;
  Future<List<model.TransactionReceiver>>? _futureDestination;
  DateTime? _selectedTime;
  bool _isLoading = false;

  void closeTransactionSet() {
    Navigator.of(context).pop();
  }  

  @override
  void initState() {
    super.initState();
    _futureDestination = TransactionMethods().getTransactionTenant();
    _futureDestination?.then((value) {
      _selectedDestination = value.first;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _destinationController.dispose();
    _amountController.dispose();
  }

  void createTransaction() async {
    setState(() {
      _isLoading = true;
    });
    //print(_selectedTime!.toIso8601String());
    String res = await TransactionMethods().createTransaction(
        rId: _selectedDestination!.rId,
        uid: _selectedDestination!.uid,
        title: _titleController.text,
        destination:_destinationController.text,
        amount: _amountController.text,
        dueDate: _selectedTime!
        );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      showSnackBar('Transaction successfully sent!', context);
      resetForm();
    }
  }

  void resetForm(){
    setState(() {
      _titleController.clear();
      _destinationController.clear();
      _amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: MediaQuery.of(context).size.width > 600 ?
      null
      :
      PreferredSize(
        preferredSize: const Size(
          double.infinity,
          kToolbarHeight
        ),
        child: AppBar(
          title: const Text(
            'Send Transaction',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor
            )
          ),
          backgroundColor: bgColor,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: primaryColor,
            onPressed: closeTransactionSet,
          ),
        ), 
      ),
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > 600 ?
          EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3)
          :
          const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              TextFieldInput(
                  textEditingController: _titleController,
                  hintText: 'Title',
                  textInputType: TextInputType.text),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _destinationController,
                  hintText: 'Destination',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              TextFieldInput(
                  textEditingController: _amountController,
                  hintText: 'Amount',
                  isPassword: false,
                  textInputType: TextInputType.text),
              const SizedBox(height: 12),
              Container(
                //height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 9),
                alignment: Alignment.topLeft,
                child: FutureBuilder<List<model.TransactionReceiver>>(
                  future: _futureDestination, 
                  builder: (context, AsyncSnapshot<List<model.TransactionReceiver>> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    //StatefulBuilder(builder: (context, setState) {
                      return DropdownButton(
                        dropdownColor: bgColor,
                        itemHeight: null,
                        isExpanded: true,
                        hint: Text(
                          'Select Renter',
                          maxLines: 3,
                          style: GoogleFonts.getFont(
                            'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            letterSpacing: -0.4,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        value: _selectedDestination,
                        items: snapshot.data!.map((destination) {
                          return DropdownMenuItem(
                            value: destination,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "${destination.propertyName} - ${destination.name} - ${destination.username}",
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  letterSpacing: -0.4,
                                  color: const Color(0xFF000000),
                                ),
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 4,
                              ),
                            )
                          );
                        }).toList(), 
                        onChanged: (value) {
                          setState(() {
                            _selectedDestination = value!;
                          });
                        }, 
                      );                                        
                    //});
                  },
                )
              ),
              const SizedBox(height: 12),
              TextField(
                onTap: () async {
                  DateTime? res = await showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: DateTime(2024), 
                    lastDate: DateTime(2025)
                  );
                  setState(() {
                    _selectedTime = res;
                    if(res != null){
                      _dateController.text = res.toString().split(" ")[0];
                    }
                  });
                },
                readOnly: true,
                style: GoogleFonts.getFont(
                    'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    letterSpacing: -0.3,
                    color: const Color.fromARGB(255, 0, 0, 0),
                ),
                controller: _dateController,
                decoration: InputDecoration(
                  fillColor: bgColor,
                  hintText: 'Date',
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: primaryColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF334B48),
                      width: 2.5
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF334B48),
                      width: 2.5
                    )
                  ),
                  hintStyle: GoogleFonts.getFont(
                    'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    letterSpacing: -0.3,
                    color: const Color.fromARGB(255, 46, 46, 46),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(8)
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: createTransaction,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: secondaryColor),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(
                        color: bgColor,
                      ))
                      : 
                      const Text('Send Transaction'),
                ),
              ),
              //const SizedBox(height: 12),
              //Flexible(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}