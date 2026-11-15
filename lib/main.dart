import 'package:flutter/material.dart';

const bg = Color(0xFFF5F7FA), surface = Colors.white, blue = Color(0xFF0194F3), teal = Color(0xFF00B4D8), orange = Color(0xFFFF5E1F), ink = Color(0xFF0F172A), muted = Color(0xFF64748B), line = Color(0xFFE2E8F0);
void main() => runApp(const TravelApp());
class TravelApp extends StatelessWidget {
  const TravelApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, title: 'Travel & Staycation',
    theme: ThemeData(useMaterial3: true, brightness: Brightness.light, scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: blue, brightness: Brightness.light, surface: surface),
      textTheme: ThemeData.light().textTheme.apply(bodyColor: ink, displayColor: ink),
      checkboxTheme: CheckboxThemeData(fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? blue : surface), checkColor: WidgetStateProperty.all(Colors.white)),
    ), home: const TravelHomePage(),
  );
}
class Leg { Leg({this.from='Jakarta (CGK)',this.to='Singapura (SIN)',this.date='20 Nov 2026'}); String from,to,date; double turns=0; }
class Place { const Place(this.name,this.country,this.rating,this.price,this.image,this.days); final String name,country,image; final double rating,price; final int days; }

class TravelHomePage extends StatefulWidget {
  const TravelHomePage({super.key});
  @override State<TravelHomePage> createState()=>_TravelHomePageState();
}
class _TravelHomePageState extends State<TravelHomePage> {
  final search=TextEditingController();
  int service=0, flightTab=0, trip=0, nav=0, adults=1, children=0, infants=0, rooms=1, trainAdults=1, trainBaby=0;
  double trainRouteTurns=0, busRouteTurns=0;
  String cabin='Ekonomi', trainClass='Ekonomi', country='All', sort='Popular', query='', language='ID', currency='IDR', hotel='Bali - Semua Area', trainFrom='Bandung (BD)', trainTo='Gambir (GMR)', busFrom='Pasteur, Bandung', busTo='Bandara Soekarno-Hatta (CGK)', rental='Bali', hotelIn='20 Nov 2026',hotelOut='22 Nov 2026', tripDate='20 Nov 2026', returnDate='22 Nov 2026', trainReturnDate='22 Nov 2026', rentalIn='20 Nov 2026',rentalOut='22 Nov 2026',clock='10:30',rentalEndClock='18:00',withDriverDuration='12 Jam',pnr='',lastName='';
  bool direct=false,returnOn=true,trainReturnOn=true;
  final saved=<String>{};
  final mainLeg=Leg();
  final legs=<Leg>[Leg(),Leg(from:'',to:'',date:'21 Nov 2026')];
  final places=<Place>[
    Place('Raja Ampat','Indonesia',4.9,750,'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=500&h=400&fit=crop',5),
    Place('Ubud, Bali','Indonesia',4.8,420,'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=500&h=400&fit=crop',3),
    Place('Mount Fuji','Japan',4.9,890,'https://images.unsplash.com/photo-1570459027562-4a916cc6113f?w=500&h=400&fit=crop',6),
    Place('Kyoto','Japan',4.8,680,'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=500&h=400&fit=crop',4),
    Place('City Rome','Italy',4.8,620,'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=500&h=400&fit=crop',4),
    Place('Venice','Italy',4.7,710,'https://images.unsplash.com/photo-1514890547357-a9ee288728e0?w=500&h=400&fit=crop',3),
    Place('Singapore','Singapore',4.7,390,'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=500&h=400&fit=crop',3),
    Place('Dubai','UAE',4.9,820,'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=500&h=400&fit=crop',4),
  ];
  @override void initState(){super.initState();search.addListener(()=>setState(()=>query=search.text.trim().toLowerCase()));}
  @override void dispose(){search.dispose();super.dispose();}
  void toast(String s){ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content:Text(s),behavior:SnackBarBehavior.floating,backgroundColor:ink));}
  @override Widget build(BuildContext context)=>Scaffold(body:Stack(children:[
    SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.fromLTRB(18,16,18,105),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      _header(),const SizedBox(height:22),Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 30, height: 1.12, fontWeight: FontWeight.w800, letterSpacing: -.8, color: ink),
          children: [
            TextSpan(text: language == 'ID' ? 'Jelajahi dunia\nyang ' : 'Explore the\nBeautiful '),
            TextSpan(text: language == 'ID' ? 'indah!' : 'World!', style: const TextStyle(color: blue)),
          ],
        ),
      ),
      const SizedBox(height:16),_searchBar(),const SizedBox(height:17),_services(),const SizedBox(height:16),_booking(),
      const SizedBox(height:24),_coupons(),const SizedBox(height:24),_places(),const SizedBox(height:24),_promoSections(),
      const SizedBox(height:24),_schedule(),const SizedBox(height:24),_tips(),
    ]))),
    Positioned(left:16,right:16,bottom:12,child:_navBar()),
  ]));
  Widget _header()=>Row(children:[
    const CircleAvatar(radius:24,backgroundColor:Color(0xFFE5F3FC),child:Icon(Icons.person,color:blue)),
    const SizedBox(width:11),const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('Hello Naufal',style:TextStyle(fontSize:12,color:muted)),Text('Good Evening!',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)),
    ])),
    InkWell(onTap:_openLocalePicker,borderRadius:BorderRadius.circular(20),child:Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:8),decoration:BoxDecoration(color:surface,borderRadius:BorderRadius.circular(20),border:Border.all(color:line)),child:Text('${language == 'ID' ? '🇮🇩 ID' : '🇬🇧 EN'} • $currency',style:const TextStyle(fontSize:10,fontWeight:FontWeight.w800)))),
    const SizedBox(width:5),Stack(children:[IconButton(onPressed:_notifications,style:IconButton.styleFrom(backgroundColor:surface,foregroundColor:ink,side:const BorderSide(color:line)),icon:const Icon(Icons.notifications_none)),
      Positioned(top:9,right:9,child:Container(width:8,height:8,decoration:const BoxDecoration(color:blue,shape:BoxShape.circle)))])
  ]);
  Widget _searchBar()=>Row(children:[
    Expanded(child:TextField(controller:search,decoration:InputDecoration(hintText:'Search hotels, flights, places...',prefixIcon:const Icon(Icons.search,color:blue),filled:true,fillColor:surface,contentPadding:const EdgeInsets.symmetric(vertical:13),border:OutlineInputBorder(borderRadius:BorderRadius.circular(28),borderSide:const BorderSide(color:line))))),
    const SizedBox(width:8),_blueIcon(Icons.tune,_openTravelFilters),
  ]);

  Future<void> _openTravelFilters() async {
    var draftCountry = country;
    var draftSort = sort;
    final filters = await showModalBottomSheet<(String, String)>(
      context: context,
      backgroundColor: surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, refreshSheet) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 18,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(color: line, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Filter destinasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Negara', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: muted)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 2,
                  children: ['All', 'Indonesia', 'Japan', 'Italy', 'Singapore', 'UAE'].map((item) =>
                    ChoiceChip(
                      label: Text(item),
                      selected: draftCountry == item,
                      showCheckmark: false,
                      selectedColor: const Color(0xFFE8F5FE),
                      labelStyle: TextStyle(
                        color: draftCountry == item ? blue : ink,
                        fontSize: 11,
                        fontWeight: draftCountry == item ? FontWeight.w700 : FontWeight.w500,
                      ),
                      side: BorderSide(color: draftCountry == item ? blue : line),
                      onSelected: (_) => refreshSheet(() => draftCountry = item),
                    ),
                  ).toList(),
                ),
                const SizedBox(height: 14),
                const Text('Urutkan destinasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: muted)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  children: ['Popular', 'Latest', 'All'].map((item) =>
                    ChoiceChip(
                      label: Text(item),
                      selected: draftSort == item,
                      showCheckmark: false,
                      selectedColor: const Color(0xFFE8F5FE),
                      labelStyle: TextStyle(
                        color: draftSort == item ? blue : ink,
                        fontSize: 11,
                        fontWeight: draftSort == item ? FontWeight.w700 : FontWeight.w500,
                      ),
                      side: BorderSide(color: draftSort == item ? blue : line),
                      onSelected: (_) => refreshSheet(() => draftSort = item),
                    ),
                  ).toList(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => refreshSheet(() {
                        draftCountry = 'All';
                        draftSort = 'Popular';
                      }),
                      child: const Text('Atur ulang'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(sheetContext, (draftCountry, draftSort)),
                          style: FilledButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          ),
                          child: const Text('Terapkan filter', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (filters != null && mounted) {
      setState(() {
        country = filters.$1;
        sort = filters.$2;
      });
    }
  }
  Widget _services(){const names=['Hotel','Tiket Pesawat','Kereta Api','Bus & Travel','Jemput Bandara','Rental Mobil','Atraksi','Lainnya'];const icons=[Icons.hotel_outlined,Icons.flight,Icons.train,Icons.directions_bus,Icons.airport_shuttle,Icons.directions_car_outlined,Icons.attractions_outlined,Icons.grid_view];
    return _card(child:GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:8,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4,mainAxisExtent:73,crossAxisSpacing:4,mainAxisSpacing:7),itemBuilder:(c,i){
      final active=service==i&&i!=7;return InkWell(onTap:(){if(i==7){_more();}else{setState((){service=i;if(i==1){flightTab=0;trip=0;}});}},child:Column(children:[
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: active ? blue : const Color(0xFFEAF6FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icons[i], color: active ? Colors.white : blue),
            ),
            if (i == 2)
              Positioned(
                top: -7,
                left: 0,
                right: 0,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'Whoosh',
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, height: 1.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height:4),Text(names[i],textAlign:TextAlign.center,maxLines:2,style:TextStyle(fontSize:9,height:1.1,fontWeight:active?FontWeight.bold:FontWeight.w500,color:active?blue:ink)),
      ]));}));
  }
  Widget _booking()=>_card(child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
    Row(children:[Expanded(child:Text(_label('Cari & Reservasi Cepat','Quick Booking'),style:const TextStyle(fontWeight:FontWeight.w800,fontSize:15))),_pill(_badgeLabel,const Color(0xFFE8F5FE),blue)]),
    const Divider(height:22,color:line),
    if(service==1)_flightForm() else _serviceForm(),
  ]));
  String get _badgeLabel=>service==1?['Tiket Pesawat','Check-in Online','Bagasi Tambahan'][flightTab]:['Hotel','','Kereta Api & Whoosh','Bus & Travel','Antar Jemput Bandara','Rental Mobil','Atraksi & Aktivitas'][service];
  Widget _serviceForm(){
    if(service==0)return Column(children:[
      _selector('Area atau hotel',hotel,Icons.location_on_outlined,'hotel'),
      const SizedBox(height:8),Row(children:[Expanded(child:_date('Check-in',hotelIn,()=>_pickDate((v)=>setState(()=>hotelIn=v)))),const SizedBox(width:8),Expanded(child:_date('Check-out',hotelOut,()=>_pickDate((v)=>setState(()=>hotelOut=v))))]),
      const SizedBox(height:8),_selector('Tamu & kamar','$rooms Kamar • $adults Dewasa, $children Anak',Icons.bed_outlined,'hotelGuests'),
      const SizedBox(height:9),_button('Cari Hotel',()=>_summary('Hotel')),
    ]);
    if (service == 2) {
      return Column(
        children: [
          _transportRoute(
            fromLabel: 'Stasiun asal',
            fromValue: trainFrom,
            toLabel: 'Stasiun tujuan',
            toValue: trainTo,
            icon: Icons.train,
            turns: trainRouteTurns,
            onFromTap: () => _openSelector('trainFrom', 'Pilih stasiun asal', trainFrom),
            onToTap: () => _openSelector('trainTo', 'Pilih stasiun tujuan', trainTo),
            onSwap: () => setState(() {
              _swapStrings(trainFrom, trainTo);
              trainRouteTurns += .5;
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _date('Tanggal berangkat', tripDate, () => _pickDate((v) => setState(() => tripDate = v)))),
              const SizedBox(width: 8),
              Expanded(child: _dateToggleTile(
                label: 'Tanggal pulang',
                enabled: trainReturnOn,
                date: trainReturnDate,
                onToggle: (value) => setState(() => trainReturnOn = value),
                onPick: () => _pickDate((value) => setState(() => trainReturnDate = value)),
              )),
            ],
          ),
          const SizedBox(height: 12),
          _selector('Penumpang & kelas', '$trainAdults Dewasa, $trainBaby Bayi • $trainClass', Icons.people_outline, 'trainGuests'),
          const SizedBox(height: 12),
          _button('Cari Tiket Kereta', () => _summary('Kereta')),
        ],
      );
    }
    if (service == 3) {
      return Column(
        children: [
          _transportRoute(
            fromLabel: 'Kota / pool asal',
            fromValue: busFrom,
            toLabel: 'Kota / pool tujuan',
            toValue: busTo,
            icon: Icons.directions_bus,
            turns: busRouteTurns,
            onFromTap: () => _openSelector('busFrom', 'Pilih kota / pool asal', busFrom),
            onToTap: () => _openSelector('busTo', 'Pilih kota / pool tujuan', busTo),
            onSwap: () => setState(() {
              _swapStrings(busFrom, busTo);
              busRouteTurns += .5;
            }),
          ),
          const SizedBox(height: 12),
          _date('Tanggal perjalanan', tripDate, () => _pickDate((v) => setState(() => tripDate = v))),
          const SizedBox(height: 12),
          _button('Cari Bus & Travel', () => _summary('Bus & Travel')),
        ],
      );
    }
    if(service==4)return Column(children:[
      _selector('Bandara penjemputan',pickupAirport,Icons.flight_takeoff,'airport'),
      const SizedBox(height:8),_selector('Area tujuan / hotel',dropArea,Icons.location_on_outlined,'hotel'),
      const SizedBox(height:8),Row(children:[Expanded(child:_date('Tanggal jemput',tripDate,()=>_pickDate((v)=>setState(()=>tripDate=v)))),const SizedBox(width:8),Expanded(child:_date('Jam jemput',clock,_pickTime))]),
      const SizedBox(height:9),_button('Cari Jemputan Bandara',()=>_summary('Antar jemput')),
    ]);
    if(service==5)return Column(children:[
      Row(children:[Expanded(child:_segment('Tanpa Sopir',!withDriver,()=>setState(()=>withDriver=false),Icons.directions_car)),const SizedBox(width:7),Expanded(child:_segment('Dengan Sopir',withDriver,()=>setState(()=>withDriver=true),Icons.person_outline))]),
      const SizedBox(height:8),_selector('Lokasi rental',rental,Icons.location_on_outlined,'rental'),
      if(withDriver)...[const SizedBox(height:8),Row(children:['12 Jam','Full Day'].map((x)=>Expanded(child:Padding(padding:const EdgeInsets.only(right:5),child:_segment(x,withDriverDuration==x,()=>setState(()=>withDriverDuration=x),Icons.schedule)))).toList())],
      const SizedBox(height:8),Row(children:[Expanded(child:_date('Tanggal mulai',rentalIn,()=>_pickDate((v)=>setState(()=>rentalIn=v)))),const SizedBox(width:8),Expanded(child:_date('Tanggal selesai',rentalOut,()=>_pickDate((v)=>setState(()=>rentalOut=v))))]),
      const SizedBox(height:8),Row(children:[Expanded(child:_date('Jam mulai',clock,_pickTime)),const SizedBox(width:8),Expanded(child:_date('Jam selesai',rentalEndClock,_pickEndTime))]),const SizedBox(height:9),_button('Cari Rental Mobil',()=>_summary('Rental mobil')),
    ]);
    return Column(children:[_selector('Cari atraksi atau tur','Universal Studios, Museum...',Icons.attractions_outlined,'activity'),const SizedBox(height:9),_button('Temukan Inspirasi',()=>_summary('Atraksi'))]);
  }
  String get pickupAirport=>_pickupAirport; String _pickupAirport='Soekarno-Hatta (CGK)';
  String get dropArea=>_dropoffArea; String _dropoffArea='SCBD, Jakarta';
  bool withDriver=false;

  Widget _flightForm() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F7FC),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(children: [
          _tab(0, 'Tiket Pesawat', Icons.flight_takeoff),
          _tab(1, 'Check-in Online', Icons.airplane_ticket_outlined),
          _tab(2, 'Bagasi Tambahan', Icons.luggage_outlined),
        ]),
      ),
      const SizedBox(height: 12),
      // Keep the body as a keyed, full-width child so each sub-tab is rebuilt
      // and laid out when selected, including inside the page scroll view.
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: SizedBox(
          key: ValueKey<String>('$flightTab-$trip'),
          width: double.infinity,
          child: _flightTabContent(),
        ),
      ),
    ],
  );

  Widget _flightTabContent() {
    if (flightTab == 1) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          onChanged: (value) => setState(() => pnr = value.trim().toUpperCase()),
          textCapitalization: TextCapitalization.characters,
          decoration: _inputDecoration('Kode Booking (PNR)', 'Contoh: XY92KL', Icons.confirmation_number_outlined),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: (value) => setState(() => lastName = value.trim()),
          textCapitalization: TextCapitalization.words,
          decoration: _inputDecoration('Nama Belakang Penumpang', 'Contoh: KARIM', Icons.person_outline),
        ),
        const SizedBox(height: 8),
        const Align(alignment: Alignment.centerLeft, child: Text(
          'Check-in online tersedia mulai 24 jam hingga 2 jam sebelum keberangkatan.',
          style: TextStyle(fontSize: 10, color: muted),
        )),
        const SizedBox(height: 10),
        _button('Lanjutkan Check-in Online', () => toast(
          pnr.isEmpty || lastName.isEmpty ? 'Lengkapi kode booking dan nama belakang.' : 'Memeriksa check-in untuk $pnr.',
        )),
      ]);
    }
    if (flightTab == 2) {
      return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Text('Bagasi Tambahan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
          const Text('Tersedia untuk rute tertentu', style: TextStyle(color: muted, fontSize: 9)),
        ]),
        const SizedBox(height: 9),
        _selector('Penerbangan', 'Masukkan Kode Booking atau Pilih Penerbangan Anda', Icons.luggage_outlined, 'airport'),
        const SizedBox(height: 10),
        const Wrap(spacing: 8, runSpacing: 7, children: [
          _Benefit('Beli sekarang agar lebih hemat'), _Benefit('Tinggal tambah dan bayar'),
          _Benefit('Pilih kapasitas sesuai kebutuhan'), _Benefit('Tambah bagasi hingga 3 kali'),
        ]),
        const SizedBox(height: 10),
        _button('Lanjut Pilih Bagasi', () => toast('Pilih penerbangan untuk melanjutkan.')),
      ]);
    }

    final routes = <Widget>[];
    if (trip == 0) {
      routes.addAll([
        _flightLeg(mainLeg),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _date('Tanggal pergi', tripDate, () => _pickDate((v) => setState(() => tripDate = v)))),
          const SizedBox(width: 8),
          Expanded(child: _returnDateTile()),
        ]),
        const SizedBox(height: 9),
        _button('Cari Penerbangan', () => _summary('Penerbangan')),
      ]);
    } else {
      for (var i = 0; i < legs.length; i++) {
        if (i > 0) routes.add(const SizedBox(height: 8));
        routes.add(_flightLeg(legs[i], number: i + 1, removable: i >= 2));
      }
      routes.addAll([
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => setState(() => legs.add(Leg(from: '', to: '', date: '23 Nov 2026'))),
          icon: const Icon(Icons.add),
          label: const Text('+ TAMBAH PENERBANGAN'),
          style: OutlinedButton.styleFrom(foregroundColor: blue, minimumSize: const Size.fromHeight(42), side: const BorderSide(color: blue)),
        ),
        const SizedBox(height: 8),
        _button('Cari Penerbangan Multi-kota', () => _summary('Penerbangan multi-kota')),
      ]);
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Expanded(
          child: _segment(
            'Sekali Jalan / Pulang Pergi',
            trip == 0,
            () => setState(() => trip = 0),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _segment(
            'Multi-kota',
            trip == 1,
            () => setState(() => trip = 1),
          ),
        ),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _selector('Penumpang & kelas', _flightSummary, Icons.people_outline, 'flightGuests')),
        if (trip == 0) ...[
          Checkbox(value: direct, onChanged: (v) => setState(() => direct = v ?? false)),
          const Text('Langsung', style: TextStyle(fontSize: 10, color: muted)),
        ],
      ]),
      const SizedBox(height: 8),
      ...routes,
    ]);
  }
  String get _flightSummary=>'$adults Dewasa, $children Anak, $infants Bayi • $cabin';
  Widget _tab(int i,String text,IconData icon)=>Expanded(child:Material(color:flightTab==i?blue:const Color(0xFFF1F5F9),borderRadius:BorderRadius.circular(10),child:InkWell(onTap:()=>setState(()=>flightTab=i),borderRadius:BorderRadius.circular(10),child:Container(constraints:const BoxConstraints(minHeight:58),padding:const EdgeInsets.symmetric(vertical:7,horizontal:3),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(icon,size:17,color:flightTab==i?Colors.white:const Color(0xFF475569)),const SizedBox(height:3),Text(text,textAlign:TextAlign.center,maxLines:2,style:TextStyle(fontSize:8,color:flightTab==i?Colors.white:const Color(0xFF475569),fontWeight:FontWeight.w700))])))));
  Widget _flightLeg(Leg leg,{int? number,bool removable=false})=>_card(padding:const EdgeInsets.all(8),child:Column(children:[
    if(number!=null)Row(children:[Expanded(child:Text('PENERBANGAN $number',style:const TextStyle(color:blue,fontSize:9,fontWeight:FontWeight.bold))),if(removable)TextButton(onPressed:()=>setState(()=>legs.remove(leg)),child:const Text('✕ Hapus',style:TextStyle(color:orange,fontSize:10)))]),
    Stack(children:[Column(children:[
      _legPlace(leg,true),
      const SizedBox(height:5),_legPlace(leg,false),
    ]),
      Positioned(right:8,top:35,child:Material(color:surface,shape:const CircleBorder(side:BorderSide(color:line)),child:InkWell(customBorder:const CircleBorder(),onTap:(){setState(() { final x=leg.from; leg.from=leg.to; leg.to=x; leg.turns+=.5; });},child:Padding(padding:const EdgeInsets.all(7),child:AnimatedRotation(turns:leg.turns,duration:const Duration(milliseconds:350),curve:Curves.easeOutBack,child:const Icon(Icons.swap_vert,color:blue,size:18)))))),
    ]),
    if(number!=null)...[const SizedBox(height:7),_date('Tanggal pergi',leg.date,()=>_pickDate((v)=>setState(()=>leg.date=v)))],
  ]));
  Widget _legPlace(Leg leg,bool isFrom)=>InkWell(onTap:()async{
    const airports=['Jakarta (CGK) - Soekarno-Hatta Int’l Airport','Bandung (BDO) - Husein Sastranegara','Denpasar-Bali (DPS) - Ngurah Rai Int’l Airport','Surabaya (SUB) - Juanda','Singapura (SIN) - Changi Int’l Airport','Tokyo (HND) - Haneda Airport','Kuala Lumpur (KUL) - KLIA'];
    final value=await _locationSheet(isFrom?'Pilih bandara asal':'Pilih bandara tujuan',airports,isFrom?leg.from:leg.to);
    if(value!=null)setState(()=>isFrom?leg.from=value:leg.to=value);
  },child:_card(padding:const EdgeInsets.symmetric(horizontal:10,vertical:8),child:Row(children:[
    Icon(isFrom?Icons.flight_takeoff:Icons.flight_land,color:blue,size:17),const SizedBox(width:8),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(isFrom?'Dari':'Ke',style:const TextStyle(color:muted,fontSize:9)),Text((isFrom?leg.from:leg.to).isEmpty?'Pilih kota / bandara':(isFrom?leg.from:leg.to),maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w700,fontSize:11)),
    ])),const Icon(Icons.keyboard_arrow_down,color:muted,size:18),
  ])));
  Widget _returnDateTile() => _dateToggleTile(
    label: 'Tanggal pulang',
    enabled: returnOn,
    date: returnDate,
    onToggle: (value) => setState(() => returnOn = value),
    onPick: () => _pickDate((value) => setState(() => returnDate = value)),
  );

  Widget _dateToggleTile({
    required String label,
    required bool enabled,
    required String date,
    required ValueChanged<bool> onToggle,
    required VoidCallback onPick,
  }) => SizedBox(
    height: 68,
    child: _card(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: enabled,
              onChanged: (value) => onToggle(value ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: muted)),
                const SizedBox(height: 3),
                Text(
                  enabled ? date : 'Sekali jalan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: enabled ? ink : muted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: enabled ? onPick : null,
            icon: const Icon(Icons.calendar_month, size: 15),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
          ),
        ],
      ),
    ),
  );

  Widget _transportRoute({
    required String fromLabel,
    required String fromValue,
    required String toLabel,
    required String toValue,
    required IconData icon,
    required double turns,
    required VoidCallback onFromTap,
    required VoidCallback onToTap,
    required VoidCallback onSwap,
  }) => _card(
    padding: const EdgeInsets.all(8),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _selector(fromLabel, fromValue, icon, '', onTap: onFromTap),
              const SizedBox(height: 8),
              _selector(toLabel, toValue, icon, '', onTap: onToTap),
            ],
          ),
        ),
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(side: BorderSide(color: line)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onSwap,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutBack,
                    child: const Icon(Icons.swap_vert, color: blue, size: 19),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  Widget _selector(String label, String value, IconData icon, String type, {VoidCallback? onTap}) =>
      InkWell(onTap: onTap ?? () => _openSelector(type, label, value), child: _card(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), child: Row(children:[
    Icon(icon,color:blue,size:17),const SizedBox(width:8),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(color:muted,fontSize:9)),Text(value,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w700,fontSize:11))])),const Icon(Icons.keyboard_arrow_down,color:muted,size:18),
  ])));
  Widget _date(String label, String value, VoidCallback tap) => SizedBox(
    height: 68,
    child: InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(16),
      child: _card(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: blue, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: muted, fontSize: 9)),
                  const SizedBox(height: 3),
                  Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Widget _segment(String text,bool active,VoidCallback tap,[IconData? icon])=>InkWell(onTap:tap,child:Container(padding:const EdgeInsets.symmetric(vertical:8,horizontal:8),decoration:BoxDecoration(color:active?const Color(0xFFE8F5FE):surface,border:Border.all(color:active?blue:line),borderRadius:BorderRadius.circular(22)),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[if(icon!=null)Icon(icon,size:14,color:blue),if(icon!=null)const SizedBox(width:4),Flexible(child:Text(text,maxLines:1,overflow:TextOverflow.ellipsis,style:TextStyle(color:active?blue:muted,fontSize:9,fontWeight:FontWeight.w700)))])));
  InputDecoration _inputDecoration(String label,String hint,IconData icon)=>InputDecoration(
    labelText:label,hintText:hint,prefixIcon:Icon(icon,color:blue,size:18),filled:true,fillColor:const Color(0xFFF8FAFC),
    contentPadding:const EdgeInsets.symmetric(horizontal:12,vertical:12),
    border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:line)),
    enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:line)),
    focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:const BorderSide(color:blue)),
  );
  Widget _button(String text,VoidCallback tap)=>SizedBox(width:double.infinity,height:44,child:FilledButton(onPressed:tap,style:FilledButton.styleFrom(backgroundColor:blue,foregroundColor:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))),child:Text(text,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:11))));
  Widget _blueIcon(IconData icon,VoidCallback tap)=>Material(color:blue,borderRadius:BorderRadius.circular(14),child:InkWell(onTap:tap,borderRadius:BorderRadius.circular(14),child:SizedBox(width:46,height:46,child:Icon(icon,color:Colors.white))));
  Widget _card({required Widget child,EdgeInsets padding=const EdgeInsets.all(11)})=>Container(width:double.infinity,padding:padding,decoration:BoxDecoration(color:surface,borderRadius:BorderRadius.circular(16),border:Border.all(color:line),boxShadow:[BoxShadow(color:ink.withValues(alpha:.045),blurRadius:12,offset:const Offset(0,4))]),child:child);
  Widget _pill(String text,Color color,Color fg)=>Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),decoration:BoxDecoration(color:color,borderRadius:BorderRadius.circular(24)),child:Text(text,style:TextStyle(color:fg,fontSize:9,fontWeight:FontWeight.w800)));

  Future<void> _openSelector(String type,String label,String current)async{
    if(type=='flightGuests'){await _flightGuestSheet();return;} if(type=='hotelGuests'){await _hotelGuestSheet();return;} if(type=='trainGuests'){await _trainGuestSheet();return;}
    if(type=='entry'){_entrySheet();return;}
    final options=switch(type){
      'hotel'=>['Bali - Semua Area · 2.450 properti','Bandung - Setiabudi & Dago · 820 properti','Jakarta - SCBD & Sudirman · 1.920 properti','Yogyakarta - Malioboro · 610 properti','Singapura - Marina Bay · 540 properti'],
      'trainFrom'||'trainTo'=>['Bandung (BD)','Padalarang (PDL) - Whoosh','Halim (HLM) - Whoosh','Gambir (GMR)','Yogyakarta (YK)','Surabaya Gubeng (SGU)'],
      'busFrom'||'busTo'=>['Pasteur, Bandung','Dipatiukur, Bandung','Bandara Soekarno-Hatta (CGK)','Blok M, Jakarta','Semarang Kota'],
      'rental'=>['Bali','Bandung','Jakarta','Yogyakarta','Medan'],
      _=>['Jakarta (CGK) - Soekarno-Hatta Int’l Airport','Bandung (BDO) - Husein Sastranegara','Denpasar-Bali (DPS) - Ngurah Rai Int’l Airport','Surabaya (SUB) - Juanda','Singapura (SIN) - Changi Int’l Airport','Tokyo (HND) - Haneda Airport','Kuala Lumpur (KUL) - KLIA'],
    };
    final picked=await _locationSheet(label,options,current);
    if(picked==null)return;
    setState((){
      switch(type){
        case 'hotel':hotel=picked;break;
        case 'trainFrom':trainFrom=picked;break;case 'trainTo':trainTo=picked;break;
        case 'busFrom':busFrom=picked;break;case 'busTo':busTo=picked;break;
        case 'rental':rental=picked;break;case 'airport':_pickupAirport=picked;break;
        case 'flightFrom':mainLeg.from=picked;break;case 'flightTo':mainLeg.to=picked;break;
        case 'activity':break;
      }
    });
  }
  Future<void> _entrySheet()async{
    final controller=TextEditingController(text:pnr);
    await showModalBottomSheet<void>(context:context,isScrollControlled:true,backgroundColor:surface,builder:(ctx)=>Padding(
      padding:EdgeInsets.fromLTRB(18,18,18,MediaQuery.of(ctx).viewInsets.bottom+18),
      child:Column(mainAxisSize:MainAxisSize.min,children:[const Align(alignment:Alignment.centerLeft,child:Text('Kode Booking (PNR) & Nama Belakang',style:TextStyle(fontWeight:FontWeight.w800))),
        const SizedBox(height:10),TextField(controller:controller,decoration:const InputDecoration(hintText:'Contoh: XY92KL - KARIM',border:OutlineInputBorder())),
        const SizedBox(height:12),_button('Simpan',(){setState(()=>pnr=controller.text);Navigator.pop(ctx);}),
      ]),
    ));
    controller.dispose();
  }
  Future<String?> _locationSheet(String title,List<String> options,String current)async{
    final ctrl=TextEditingController();var filtered=options;
    final result=await showModalBottomSheet<String>(context:context,isScrollControlled:true,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),builder:(ctx)=>StatefulBuilder(builder:(ctx,setSheet)=>SafeArea(child:Padding(padding:EdgeInsets.fromLTRB(18,16,18,MediaQuery.of(ctx).viewInsets.bottom+16),child:SizedBox(height:MediaQuery.of(ctx).size.height*.68,child:Column(children:[
      Container(width:38,height:4,decoration:BoxDecoration(color:line,borderRadius:BorderRadius.circular(4))),const SizedBox(height:15),Align(alignment:Alignment.centerLeft,child:Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800))),
      const SizedBox(height:12),TextField(controller:ctrl,onChanged:(q)=>setSheet(()=>filtered=options.where((x)=>x.toLowerCase().contains(q.toLowerCase())).toList()),decoration:InputDecoration(hintText:'Cari lokasi',prefixIcon:const Icon(Icons.search,color:blue),filled:true,fillColor:bg,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:BorderSide.none))),
      Expanded(child:ListView.separated(itemCount:filtered.length,separatorBuilder:(_,__)=>const Divider(height:1,color:line),itemBuilder:(_,i)=>ListTile(leading:const Icon(Icons.place_outlined,color:blue),title:Text(filtered[i].split(' · ').first,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700)),subtitle:filtered[i].contains(' · ')?Text(filtered[i].split(' · ').last,style:const TextStyle(color:muted,fontSize:10)):null,trailing:current==filtered[i]?const Icon(Icons.check_circle,color:blue):null,onTap:()=>Navigator.pop(ctx,filtered[i].split(' · ').first)))),
    ]))))));
    ctrl.dispose();return result;
  }
  Future<void> _flightGuestSheet()async{await showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),builder:(ctx)=>StatefulBuilder(builder:(ctx,refresh)=>_sheet('Penumpang & kelas kabin',[
    _step('Dewasa','12+ tahun',adults,1,(v)=>adults=v,refresh),_step('Anak','2–11 tahun',children,0,(v)=>children=v,refresh),_step('Bayi','Di bawah 2 tahun',infants,0,(v)=>infants=v,refresh),
    const SizedBox(height:10),const Align(alignment:Alignment.centerLeft,child:Text('Kelas kabin',style:TextStyle(fontWeight:FontWeight.bold))),
    Wrap(spacing:6,children:['Ekonomi','Ekonomi Premium','Bisnis','First Class'].map((x)=>ChoiceChip(label:Text(x),selected:cabin==x,onSelected:(_)=>setState(()=>cabin=x),selectedColor:const Color(0xFFE8F5FE))).toList()),
    const SizedBox(height:10),_button('Simpan',()=>Navigator.pop(ctx)),
  ])));}
  Future<void> _hotelGuestSheet()async{await showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),builder:(ctx)=>StatefulBuilder(builder:(ctx,r)=>_sheet('Tamu & kamar',[
    _step('Kamar','',rooms,1,(v)=>rooms=v,r),_step('Dewasa','Usia 12+',adults,1,(v)=>adults=v,r),_step('Anak','Usia 0–11',children,0,(v)=>children=v,r),_button('Simpan',()=>Navigator.pop(ctx)),
  ])));}
  Future<void> _trainGuestSheet()async{await showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),builder:(ctx)=>StatefulBuilder(builder:(ctx,r)=>_sheet('Penumpang & kelas kereta',[
    _step('Dewasa','',trainAdults,1,(v)=>trainAdults=v,r),_step('Bayi','',trainBaby,0,(v)=>trainBaby=v,r),
    Wrap(spacing:5,children:['Ekonomi','Bisnis','Eksekutif','First Class Whoosh'].map((x)=>ChoiceChip(label:Text(x),selected:trainClass==x,onSelected:(_)=>setState(()=>trainClass=x),selectedColor:const Color(0xFFE8F5FE))).toList()),_button('Simpan',()=>Navigator.pop(ctx)),
  ])));}
  Widget _sheet(String title,List<Widget> children)=>SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(18,18,18,22),child:Column(mainAxisSize:MainAxisSize.min,children:[Align(alignment:Alignment.centerLeft,child:Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800))),const SizedBox(height:12),...children])));
  Widget _step(String title,String sub,int count,int min,ValueChanged<int> setValue,StateSetter refresh)=>Padding(padding:const EdgeInsets.symmetric(vertical:4),child:Row(children:[
    Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontWeight:FontWeight.bold)),if(sub.isNotEmpty)Text(sub,style:const TextStyle(color:muted,fontSize:10))])),
    IconButton(onPressed:count>min?(){setState(()=>setValue(count-1));refresh((){});}:null,icon:const Icon(Icons.remove_circle_outline,color:blue)),
    Text('$count',style:const TextStyle(fontWeight:FontWeight.bold)),IconButton(onPressed:(){setState(()=>setValue(count+1));refresh((){});},icon:const Icon(Icons.add_circle_outline,color:blue)),
  ]));
  Future<void> _pickDate(ValueChanged<String> onPick)async{
    final now=DateTime.now();final d=await showDatePicker(context:context,initialDate:DateTime(2026,11,20).isBefore(now)?now:DateTime(2026,11,20),firstDate:DateTime(now.year,now.month,now.day),lastDate:DateTime(2035),builder:(c,w)=>Theme(data:Theme.of(c).copyWith(colorScheme:const ColorScheme.light(primary:blue,onPrimary:Colors.white,surface:surface,onSurface:ink)),child:w!));
    if(d!=null){const months=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];onPick('${d.day.toString().padLeft(2,'0')} ${months[d.month-1]} ${d.year}');}
  }
  Future<void> _pickTime()async{final t=await showTimePicker(context:context,initialTime:TimeOfDay.now(),builder:(c,w)=>Theme(data:Theme.of(c).copyWith(colorScheme:const ColorScheme.light(primary:blue,surface:surface,onSurface:ink)),child:w!));if(t!=null)setState(()=>clock=t.format(context));}
  Future<void> _pickEndTime()async{final t=await showTimePicker(context:context,initialTime:const TimeOfDay(hour:18,minute:0),builder:(c,w)=>Theme(data:Theme.of(c).copyWith(colorScheme:const ColorScheme.light(primary:blue,surface:surface,onSurface:ink)),child:w!));if(t!=null)setState(()=>rentalEndClock=t.format(context));}
  void _swapStrings(String a,String b){if(service==2){trainFrom=b;trainTo=a;}else{busFrom=b;busTo=a;}}
  void _summary(String title)=>showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),builder:(c)=>_sheet('Ringkasan $title',[
    _card(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(service==1?'${mainLeg.from} → ${mainLeg.to}':_badgeLabel,style:const TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:5),Text(service==1?_flightSummary:service==0?'$rooms kamar • $adults dewasa, $children anak':'Tanggal $tripDate',style:const TextStyle(color:muted))])),
    const SizedBox(height:12),_button('Selesai',()=>Navigator.pop(c)),
  ]));
  void _notifications()=>showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),builder:(c)=>_sheet('Notifikasi',const [
    ListTile(leading:Icon(Icons.flight,color:blue),title:Text('Diskon Kilat Tiket Pesawat!'),subtitle:Text('Cashback 15% rute Jakarta – Bali hari ini.')),
    ListTile(leading:Icon(Icons.event_available,color:teal),title:Text('Check-in Pengingat'),subtitle:Text('Trip Niagara Falls dimulai dalam 3 hari.')),
  ]));
  void _more()=>showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),builder:(c)=>_sheet('Produk Lainnya',[
    const ListTile(leading:Icon(Icons.verified_user_outlined,color:blue),title:Text('Asuransi Perjalanan'),subtitle:Text('Proteksi liburan komprehensif')),
    const Wrap(spacing:8,runSpacing:8,children:[_Tag('Spa & Kecantikan'),_Tag('Taman Bermain'),_Tag('Kursus & Workshop'),_Tag('Acara'),_Tag('Atraksi'),_Tag('Tur'),_Tag('Kapal Pesiar')]),
  ]));

  Widget _swap(VoidCallback action)=>IconButton(onPressed:action,icon:const Icon(Icons.swap_vert,color:blue));
  Future<void> _pickDateAlt(ValueChanged<String> apply) async {
    final now=DateTime.now(), desired=DateTime(2026,11,20);
    final d=await showDatePicker(context:context,initialDate:desired.isBefore(now)?now:desired,firstDate:DateTime(now.year,now.month,now.day),lastDate:DateTime(2035),
      builder:(c,w)=>Theme(data:Theme.of(c).copyWith(colorScheme:const ColorScheme.light(primary:blue,onPrimary:Colors.white,surface:surface,onSurface:ink)),child:w!));
    if(d!=null){const m=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];apply('${d.day.toString().padLeft(2,'0')} ${m[d.month-1]} ${d.year}');}
  }
  Future<void> _pickTimeAlt() async {
    final t=await showTimePicker(context:context,initialTime:TimeOfDay.now(),
      builder:(c,w)=>Theme(data:Theme.of(c).copyWith(colorScheme:const ColorScheme.light(primary:blue,surface:surface,onSurface:ink)),child:w!));
    if(t!=null)setState(()=>clock=t.format(context));
  }
  Future<void> _openSelectorAlt(String type,String label,String current) async {
    if(type=='flightGuests'){await _guestSheet();return;}
    if(type=='hotelGuests'){await _hotelSheet();return;}
    if(type=='trainGuests'){await _trainSheet();return;}
    if(type=='entry'){toast('Masukkan kode booking dan nama belakang.');return;}
    final options=switch(type){
      'hotel'=>['Bali - Semua Area · 2.450 properti','Bandung - Setiabudi & Dago · 820 properti','Jakarta - SCBD & Sudirman · 1.920 properti','Yogyakarta - Malioboro · 610 properti','Singapura - Marina Bay · 540 properti'],
      'trainFrom'||'trainTo'=>['Bandung (BD)','Padalarang (PDL) - Whoosh','Halim (HLM) - Whoosh','Gambir (GMR)','Yogyakarta (YK)','Surabaya Gubeng (SGU)'],
      'busFrom'||'busTo'=>['Pasteur, Bandung','Dipatiukur, Bandung','Bandara Soekarno-Hatta (CGK)','Blok M, Jakarta','Semarang Kota'],
      'rental'=>['Bali','Bandung','Jakarta','Yogyakarta','Medan'],
      _=>['Jakarta (CGK) - Soekarno-Hatta Int’l Airport','Bandung (BDO) - Husein Sastranegara','Denpasar-Bali (DPS) - Ngurah Rai Int’l Airport','Surabaya (SUB) - Juanda','Singapura (SIN) - Changi Int’l Airport','Tokyo (HND) - Haneda Airport','Kuala Lumpur (KUL) - KLIA'],
    };
    final controller=TextEditingController(); var filtered=options;
    final selected=await showModalBottomSheet<String>(context:context,isScrollControlled:true,backgroundColor:surface,
      shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),
      builder:(ctx)=>StatefulBuilder(builder:(ctx,refresh)=>SafeArea(child:Padding(
        padding:EdgeInsets.fromLTRB(18,16,18,MediaQuery.of(ctx).viewInsets.bottom+16),
        child:SizedBox(height:MediaQuery.of(ctx).size.height*.68,child:Column(children:[
          Text(label,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:17)),
          const SizedBox(height:10),TextField(controller:controller,onChanged:(q)=>refresh(()=>filtered=options.where((x)=>x.toLowerCase().contains(q.toLowerCase())).toList()),
            decoration:InputDecoration(hintText:'Cari lokasi',prefixIcon:const Icon(Icons.search,color:blue),filled:true,fillColor:bg,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:BorderSide.none))),
          Expanded(child:ListView.builder(itemCount:filtered.length,itemBuilder:(c,i)=>ListTile(
            leading:const Icon(Icons.place_outlined,color:blue),title:Text(filtered[i].split(' · ').first,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700)),
            subtitle:filtered[i].contains(' · ')?Text(filtered[i].split(' · ').last,style:const TextStyle(fontSize:10,color:muted)):null,
            onTap:()=>Navigator.pop(ctx,filtered[i].split(' · ').first),
          ))),
        ]))),
      )),
    );
    controller.dispose();
    if(selected==null)return;
    setState((){
      switch(type){
        case'hotel':hotel=selected;break;case'trainFrom':trainFrom=selected;break;case'trainTo':trainTo=selected;break;
        case'busFrom':busFrom=selected;break;case'busTo':busTo=selected;break;case'rental':rental=selected;break;
        case'airport':_pickupAirport=selected;break;case'flightFrom':mainLeg.from=selected;break;case'flightTo':mainLeg.to=selected;break;
      }
    });
  }
  Future<void> _guestSheet() async => _countsSheet('Penumpang & kelas kabin',[
    ('Dewasa 12+',adults,1,(v){adults=v;}),('Anak 2–11',children,0,(v){children=v;}),('Bayi <2',infants,0,(v){infants=v;}),
  ],classes:['Ekonomi','Ekonomi Premium','Bisnis','First Class'],selected:cabin,onClass:(v)=>cabin=v);
  Future<void> _hotelSheet() async => _countsSheet('Tamu & kamar',[
    ('Kamar',rooms,1,(v){rooms=v;}),('Dewasa',adults,1,(v){adults=v;}),('Anak',children,0,(v){children=v;}),
  ]);
  Future<void> _trainSheet() async => _countsSheet('Penumpang & kelas kereta',[
    ('Dewasa',trainAdults,1,(v){trainAdults=v;}),('Bayi',trainBaby,0,(v){trainBaby=v;}),
  ],classes:['Ekonomi','Bisnis','Eksekutif','First Class Whoosh'],selected:trainClass,onClass:(v)=>trainClass=v);
  Future<void> _countsSheet(String title,List<(String,int,int,ValueChanged<int>)> items,{List<String> classes=const [],String? selected,ValueChanged<String>? onClass}) async {
    await showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),
      builder:(ctx)=>StatefulBuilder(builder:(ctx,refresh)=>SafeArea(child:Padding(padding:const EdgeInsets.all(18),child:Column(mainAxisSize:MainAxisSize.min,children:[
        Align(alignment:Alignment.centerLeft,child:Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800))),
        ...items.map((item)=>Row(children:[
          Expanded(child:Text(item.$1,style:const TextStyle(fontWeight:FontWeight.w700))),
          IconButton(onPressed:item.$2>item.$3?(){setState(()=>item.$4(item.$2-1));refresh((){});}:null,icon:const Icon(Icons.remove_circle_outline,color:blue)),
          Text('${item.$2}',style:const TextStyle(fontWeight:FontWeight.bold)),
          IconButton(onPressed:(){setState(()=>item.$4(item.$2+1));refresh((){});},icon:const Icon(Icons.add_circle_outline,color:blue)),
        ])),
        if(classes.isNotEmpty)...[
          const Align(alignment:Alignment.centerLeft,child:Text('Kelas',style:TextStyle(fontWeight:FontWeight.bold))),
          Wrap(spacing:5,children:classes.map((x)=>ChoiceChip(label:Text(x),selected:selected==x,onSelected:(_){setState(()=>onClass!(x));refresh((){});},selectedColor:const Color(0xFFE8F5FE))).toList()),
        ],
        const SizedBox(height:10),_button('Simpan',()=>Navigator.pop(ctx)),
      ])))));
  }
  void _summaryAlt(String title)=>showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),
    builder:(ctx)=>Padding(padding:const EdgeInsets.all(18),child:Column(mainAxisSize:MainAxisSize.min,children:[
      Text('Ringkasan $title',style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800)),
      const SizedBox(height:10),_card(child:Text(service==1?'${mainLeg.from} → ${mainLeg.to}':_badgeLabel,style:const TextStyle(fontWeight:FontWeight.bold))),
      const SizedBox(height:12),_button('Selesai',()=>Navigator.pop(ctx)),
    ])));
  void _notificationsAlt()=>showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),
    builder:(ctx)=>_sheet('Notifikasi',const [
      ListTile(leading:Icon(Icons.flight,color:blue),title:Text('Diskon kilat tiket pesawat'),subtitle:Text('Cashback 15% rute Jakarta – Bali.')),
      ListTile(leading:Icon(Icons.event_available,color:teal),title:Text('Check-in pengingat'),subtitle:Text('Trip Niagara Falls dimulai dalam 3 hari.')),
    ]));
  Widget _sheetAlt(String title,List<Widget> children)=>SafeArea(child:Padding(padding:const EdgeInsets.all(18),child:Column(mainAxisSize:MainAxisSize.min,children:[Align(alignment:Alignment.centerLeft,child:Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800))),...children])));
  void _moreAlt()=>showModalBottomSheet<void>(context:context,backgroundColor:surface,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(24))),
    builder:(ctx)=>_sheet('Produk Lainnya',const [
      ListTile(leading:Icon(Icons.verified_user_outlined,color:blue),title:Text('Asuransi Perjalanan'),subtitle:Text('Proteksi liburan komprehensif')),
      Wrap(spacing:8,runSpacing:8,children:[_Tag('Spa & Kecantikan'),_Tag('Taman Bermain'),_Tag('Kursus & Workshop'),_Tag('Acara'),_Tag('Atraksi'),_Tag('Tur'),_Tag('Kapal Pesiar')]),
    ]));

  Widget _coupons()=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(_label('Kupon Pengguna Baru','New User Coupons'),style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800)),const SizedBox(height:9),SizedBox(height:150,child:ListView(scrollDirection:Axis.horizontal,children:[
    _coupon('Diskon Hotel Pertama','Hemat s.d. Rp 250rb','NEWSTAY250',blue),const SizedBox(width:9),_coupon('Tiket Pesawat & Kereta','Cashback 15% Poin','TERBANGYUK',orange),
  ]))]);
  Widget _coupon(String title,String detail,String code,Color color)=>Container(width:255,padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:surface,borderRadius:BorderRadius.circular(16),border:Border.all(color:line),boxShadow:[BoxShadow(color:ink.withValues(alpha:.04),blurRadius:12)]),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(title.toUpperCase(),style:TextStyle(color:color,fontSize:9,fontWeight:FontWeight.w800)),const SizedBox(height:7),Text(detail,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:14)),const Spacer(),const Divider(height:12),
    Row(children:[Expanded(child:Text(code,style:TextStyle(color:color,fontWeight:FontWeight.w800,fontSize:11))),TextButton(onPressed:()=>toast('Kode $code disalin'),child:const Text('Salin'))]),
  ]));
  String _label(String id, String en) => language == 'ID' ? id : en;

  String _groupPrice(int value) {
    final digits = value.toString();
    final out = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write('.');
      out.write(digits[i]);
    }
    return out.toString();
  }

  String _formatPrice(double usd) {
    final amount = switch (currency) {
      'IDR' => (usd * 15470).round(),
      'SGD' => (usd * 1.35).round(),
      'JPY' => (usd * 153.3).round(),
      _ => usd.round(),
    };
    return switch (currency) {
      'IDR' => 'Rp ${_groupPrice(amount)}',
      'SGD' => 'S\$${_groupPrice(amount)}',
      'JPY' => '¥${_groupPrice(amount)}',
      _ => '\$${_groupPrice(amount)}',
    };
  }

  Future<void> _openLocalePicker() async {
    var nextLanguage = language;
    var nextCurrency = currency;
    final selection = await showModalBottomSheet<(String, String)>(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, refresh) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Bahasa & Mata Uang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              const Text('Pilih Bahasa', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: muted)),
              Wrap(spacing: 8, children: [
                for (final option in [('ID', 'Indonesia (ID)'), ('EN', 'English (EN)')])
                  ChoiceChip(label: Text(option.$2), selected: nextLanguage == option.$1,
                    onSelected: (_) => refresh(() => nextLanguage = option.$1),
                    selectedColor: const Color(0xFFE8F5FE), side: BorderSide(color: nextLanguage == option.$1 ? blue : line)),
              ]),
              const SizedBox(height: 12),
              const Text('Pilih Mata Uang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: muted)),
              Wrap(spacing: 8, children: [
                for (final option in [('IDR', 'IDR (Rp)'), ('USD', r'USD ($)'), ('SGD', r'SGD (S$)'), ('JPY', 'JPY (¥)')])
                  ChoiceChip(label: Text(option.$2), selected: nextCurrency == option.$1,
                    onSelected: (_) => refresh(() => nextCurrency = option.$1),
                    selectedColor: const Color(0xFFE8F5FE), side: BorderSide(color: nextCurrency == option.$1 ? blue : line)),
              ]),
              const SizedBox(height: 14),
              _button('Terapkan', () => Navigator.pop(sheetContext, (nextLanguage, nextCurrency))),
            ]),
          ),
        ),
      ),
    );
    if (selection != null && mounted) {
      setState(() {
        language = selection.$1;
        currency = selection.$2;
      });
    }
  }

  ({String description, List<(String, double)> spots, List<Place> recommendations}) _destinationInfo(Place p) {
    final photos = places.map((place) => place.image).toList();
    final rec = (String name, double rating, double price, String image) => Place(name, p.country, rating, price, image, 1);
    return switch (p.name) {
      'Raja Ampat' => (
        description: 'Jelajahi gugusan pulau dan perairan jernih Raja Ampat, rumah bagi terumbu karang yang luar biasa. Paket ini memberi waktu untuk menikmati alam dan budaya lokal.',
        spots: [('Piaynemo Viewpoint', 35.0), ('Wayag Islands', 50.0), ('Desa Wisata Arborek', 10.0)],
        recommendations: [rec('Nusa Penida Tour', 4.8, 65, photos[1]), rec('Bromo Sunrise Trip', 4.9, 55, photos[0])],
      ),
      'Ubud, Bali' => (
        description: 'Nikmati sawah terasering, seni, dan suasana tenang Ubud. Jelajahi desa dengan pemandu lokal dan waktu bebas untuk menikmati kuliner Bali.',
        spots: [('Tegallalang Rice Terrace', 10.0), ('Sacred Monkey Forest', 8.0), ('Tirta Empul Temple', 5.0)],
        recommendations: [rec('Nusa Penida Tour', 4.8, 65, photos[0]), rec('Bromo Sunrise Trip', 4.9, 55, photos[2])],
      ),
      'Mount Fuji' => (
        description: 'Saksikan panorama ikonik Gunung Fuji dan danau-danau di sekitarnya. Rute dipilih untuk menikmati pemandangan dengan nyaman sepanjang perjalanan.',
        spots: [('Fuji Subaru Line 5th Station', 15.0), ('Lake Kawaguchi', 10.0), ('Oshino Hakkai', 5.0)],
        recommendations: [rec('Kyoto Fushimi Inari', 4.9, 40, photos[3]), rec('Tokyo teamLab Planets', 4.8, 35, photos[2])],
      ),
      'Kyoto' => (
        description: 'Temukan kuil bersejarah, jalan tradisional, dan taman yang tenang di Kyoto. Kota ini menawarkan perpaduan budaya klasik dan kehidupan modern Jepang.',
        spots: [('Fushimi Inari Taisha', 0.0), ('Kinkaku-ji', 5.0), ('Arashiyama Bamboo Grove', 0.0)],
        recommendations: [rec('Mount Fuji Day Trip', 4.9, 89, photos[2]), rec('Tokyo teamLab Planets', 4.8, 35, photos[3])],
      ),
      'City Rome' => (
        description: 'Jelajahi pusat sejarah Roma, dari reruntuhan kuno hingga piazza yang hidup. Paket ini menggabungkan landmark utama dengan waktu untuk menikmati kota.',
        spots: [('Colosseum', 18.0), ('Vatican Museums', 25.0), ('Trevi Fountain', 0.0)],
        recommendations: [rec('Venice Gondola & San Marco', 4.8, 75, photos[5]), rec('Amalfi Coast Day Trip', 4.9, 95, photos[4])],
      ),
      'Venice' => (
        description: 'Nikmati kanal-kanal Venice, arsitektur bersejarah, dan suasana romantis kota laguna. Jelajahi landmark utama dengan berjalan kaki dan naik gondola.',
        spots: [('St. Mark’s Basilica', 3.0), ('Doge’s Palace', 30.0), ('Grand Canal Gondola', 45.0)],
        recommendations: [rec('Rome Colosseum Tour', 4.9, 62, photos[4]), rec('Amalfi Coast Day Trip', 4.9, 95, photos[5])],
      ),
      'Singapore' => (
        description: 'Temukan taman futuristis, kuliner, dan kawasan tepi laut Singapura. Destinasi ringkas yang mudah dijelajahi dalam beberapa hari.',
        spots: [('Gardens by the Bay', 22.0), ('Marina Bay Sands SkyPark', 32.0), ('Sentosa Island', 18.0)],
        recommendations: [rec('Universal Studios Singapore', 4.8, 78, photos[6]), rec('Singapore Night Safari', 4.7, 45, photos[6])],
      ),
      _ => (
        description: 'Rasakan perpaduan arsitektur modern, budaya, dan pengalaman gurun yang khas. Nikmati landmark utama dan pilihan aktivitas untuk berbagai gaya perjalanan.',
        spots: [('Burj Khalifa At The Top', 45.0), ('Dubai Marina Cruise', 35.0), ('Desert Safari', 65.0)],
        recommendations: [rec('Abu Dhabi City Tour', 4.8, 80, photos[7]), rec('Dubai Old Town Walk', 4.7, 30, photos[7])],
      ),
    };
  }

  void _openPlaceDetails(Place place) {
    final info = _destinationInfo(place);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, refreshSheet) => Container(
          height: MediaQuery.sizeOf(sheetContext).height * .85,
          decoration: const BoxDecoration(color: surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(children: [
            Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(place.image, width: double.infinity, height: 220, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 220, color: bg))),
                Positioned(top: 12, left: 14, child: _roundAction(Icons.close, () => Navigator.pop(sheetContext))),
                Positioned(top: 12, right: 14, child: _roundAction(
                  saved.contains(place.name) ? Icons.bookmark : Icons.bookmark_border,
                  () { setState(() => saved.contains(place.name) ? saved.remove(place.name) : saved.add(place.name)); refreshSheet(() {}); },
                )),
                Positioned(left: 18, right: 18, bottom: 15, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(place.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                  Text(place.country, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ])),
              ]),
              Padding(padding: const EdgeInsets.fromLTRB(18, 16, 18, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.star, color: orange, size: 18), Text(' ${place.rating}  •  ${place.days} hari', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  const Spacer(), Text(_formatPrice(place.price), style: const TextStyle(color: blue, fontWeight: FontWeight.w800, fontSize: 18)),
                ]),
                const SizedBox(height: 12),
                Text(info.description, style: const TextStyle(color: muted, height: 1.45, fontSize: 13)),
                const SizedBox(height: 14),
                const Text('Termasuk dalam paket', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                const Wrap(spacing: 7, runSpacing: 7, children: [
                  _Tag('Tiket Masuk'), _Tag('Pemandu Lokal'), _Tag('Transportasi'),
                ]),
                const SizedBox(height: 16),
                const Text('Spot Wajib Dikunjungi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                for (final spot in info.spots) ListTile(
                  dense: true, contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.place_outlined, color: blue),
                  title: Text(spot.$1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  trailing: Text(spot.$2 == 0 ? 'Gratis' : _formatPrice(spot.$2), style: const TextStyle(fontSize: 11, color: muted)),
                ),
                const SizedBox(height: 10),
                const Text('Rekomendasi di negara ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                for (final item in info.recommendations) _recommendation(item),
                const SizedBox(height: 14),
              ])),
            ]))),
            Padding(padding: EdgeInsets.fromLTRB(18, 10, 18, MediaQuery.viewPaddingOf(sheetContext).bottom + 12),
              child: _button('Pesan Paket Wisata Ini', () {
                Navigator.pop(sheetContext);
                toast('Paket ${place.name} dipilih');
              })),
          ]),
        ),
      ),
    );
  }

  Widget _roundAction(IconData icon, VoidCallback action) => Material(
    color: Colors.white.withValues(alpha: .94), shape: const CircleBorder(),
    child: IconButton(onPressed: action, icon: Icon(icon, color: ink), visualDensity: VisualDensity.compact),
  );

  Widget _recommendation(Place place) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(place.image, width: 54, height: 54, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(width: 54, height: 54, color: bg))),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        Text('★ ${place.rating}', style: const TextStyle(fontSize: 10, color: orange)),
      ])),
      Text(_formatPrice(place.price), style: const TextStyle(fontSize: 11, color: blue, fontWeight: FontWeight.w800)),
    ]),
  );

  Widget _places() {
    final shown = places.where((p) =>
      (country == 'All' || p.country == country) &&
      (query.isEmpty || p.name.toLowerCase().contains(query) || p.country.toLowerCase().contains(query))
    ).toList();
    if (sort == 'Popular') shown.sort((a, b) => b.rating.compareTo(a.rating));
    if (sort == 'Latest') shown.setAll(0, shown.reversed.toList());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle(_label('Travel Places','Travel Places'), language == 'ID' ? 'Lihat semua' : 'See all'),
      const SizedBox(height: 8),
      SizedBox(height: 36, child: ListView(
        scrollDirection: Axis.horizontal,
        children: ['All', 'Indonesia', 'Japan', 'Italy', 'Singapore', 'UAE'].map((x) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: ChoiceChip(
            label: Text(x), selected: country == x, showCheckmark: false,
            onSelected: (_) => setState(() => country = x),
            selectedColor: blue, backgroundColor: surface,
            labelStyle: TextStyle(color: country == x ? Colors.white : ink, fontSize: 9),
            side: BorderSide(color: country == x ? blue : line),
          ),
        )).toList(),
      )),
      const SizedBox(height: 10),
      SizedBox(height: 268, child: Row(children: [
        SizedBox(width: 38, child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Popular', 'Latest', 'All'].map((x) => InkWell(
            onTap: () => setState(() => sort = x),
            child: Row(children: [
              Container(width: 3, height: 27, color: sort == x ? blue : Colors.transparent),
              const SizedBox(width: 4),
              RotatedBox(quarterTurns: 3, child: Text(x.toUpperCase(),
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: sort == x ? blue : muted))),
            ]),
          )).toList(),
        )),
        Expanded(child: shown.isEmpty
          ? const Center(child: Text('Tidak ada destinasi', style: TextStyle(color: muted, fontSize: 12)))
          : ListView.separated(
              scrollDirection: Axis.horizontal, itemCount: shown.length,
              separatorBuilder: (_, __) => const SizedBox(width: 9),
              itemBuilder: (c, i) => _placeCard(shown[i]),
            )),
      ])),
    ]);
  }
  Widget _placeCard(Place place) => Material(
    color: surface,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      borderRadius: BorderRadius.circular(17),
      onTap: () => _openPlaceDetails(place),
      child: Container(
        width: 195,
        height: 268,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: line),
          boxShadow: [BoxShadow(color: ink.withValues(alpha: .04), blurRadius: 10)],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(place.image, height: 145, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 145, color: bg)),
            ),
            Positioned(top: 3, right: 3, child: IconButton(
              onPressed: () => setState(() => saved.contains(place.name) ? saved.remove(place.name) : saved.add(place.name)),
              icon: Icon(saved.contains(place.name) ? Icons.bookmark : Icons.bookmark_border, color: saved.contains(place.name) ? blue : ink),
              style: IconButton.styleFrom(backgroundColor: Colors.white, visualDensity: VisualDensity.compact),
            )),
            Positioned(bottom: 6, right: 6, child: _pill(_formatPrice(place.price), surface, ink)),
          ]),
          const SizedBox(height: 10),
          Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 4),
          Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: muted), const SizedBox(width: 3),
            Expanded(child: Text(place.country, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted, fontSize: 12))),
          ]),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('★ ' + place.rating.toStringAsFixed(1), style: const TextStyle(color: orange, fontWeight: FontWeight.bold, fontSize: 11)),
            _pill(place.days.toString() + ' Days', const Color(0xFFE8F5FE), blue),
          ]),
        ]),
      ),
    ),
  );
  Widget _promoSections()=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    _sectionTitle('Promo Tiket Pesawat','Semua rute'),const SizedBox(height:8),SizedBox(height:120,child:ListView(scrollDirection:Axis.horizontal,children:[_promo('Garuda Indonesia','CGK → DPS','Rp 1.120.000','Hemat 20%'),const SizedBox(width:8),_promo('AirAsia','BDO → SIN','Rp 699.000','Flash Sale')])),
    const SizedBox(height:18),_sectionTitle('Promo Tiket Hotel','Lihat semua'),const SizedBox(height:8),SizedBox(height:120,child:ListView(scrollDirection:Axis.horizontal,children:[_promo('Padma Resort Ubud','Gianyar, Bali','Rp 2.080.000','Diskon 35%'),const SizedBox(width:8),_promo('The Gaia Hotel','Bandung','Rp 1.590.000','Staycation')])),
    const SizedBox(height:18),_sectionTitle('Promo Tiket Atraksi','Eksplor'),const SizedBox(height:8),Row(children:[Expanded(child:_smallPromo('Universal Studios SG','Sentosa Island','Rp 945.000')),const SizedBox(width:8),Expanded(child:_smallPromo('TeamLab Planets','Toyosu, Jepang','Rp 410.000'))]),
  ]);
  Widget _promo(String name,String route,String price,String promo)=>Container(width:225,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:surface,borderRadius:BorderRadius.circular(15),border:Border.all(color:line)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:Text(name,overflow:TextOverflow.ellipsis,style:const TextStyle(color:blue,fontWeight:FontWeight.bold,fontSize:10))),_pill(promo,const Color(0xFFFFF1EB),orange)]),const Spacer(),Text(route,style:const TextStyle(fontWeight:FontWeight.bold)),const Divider(height:12),Text(price,style:const TextStyle(color:blue,fontWeight:FontWeight.w800))]));
  Widget _smallPromo(String a,String b,String c)=>_card(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Icon(Icons.local_activity_outlined,color:blue),Text(a,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:10)),Text(b,style:const TextStyle(color:muted,fontSize:9)),Text(c,style:const TextStyle(color:blue,fontWeight:FontWeight.bold,fontSize:10))]));
  Widget _schedule()=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[_sectionTitle(_label('Jadwal Saya','My Schedule'),language == 'ID' ? 'Lihat semua' : 'See all'),const SizedBox(height:8),_scheduleCard('Niagara Falls','Canada','18 - 22 Oct'),const SizedBox(height:8),_scheduleCard('Burj Khalifa','Dubai, UAE','02 - 07 Nov')]);
  Widget _scheduleCard(String a,String b,String c)=>_card(child:Row(children:[const CircleAvatar(backgroundColor:Color(0xFFE8F5FE),child:Icon(Icons.landscape,color:blue)),const SizedBox(width:9),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(a,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:11)),Text(b,style:const TextStyle(color:muted,fontSize:9)),Text(c,style:const TextStyle(color:blue,fontSize:9))])),_pill('Joined',const Color(0xFFE8F5FE),blue)]));
  Widget _tips()=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[_sectionTitle('Tips & Inspirasi Perjalanan','Baca artikel'),const SizedBox(height:8),_tip('Panduan Wisata','7 Pantai Tersembunyi di Nusa Penida yang Wajib Dikunjungi'),const SizedBox(height:7),_tip('Tips Hemat','Trik Berburu Tiket Pesawat Murah untuk Liburan Akhir Tahun')]);
  Widget _tip(String a,String b)=>_card(child:Row(children:[const Icon(Icons.travel_explore,color:teal,size:30),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(a.toUpperCase(),style:const TextStyle(color:teal,fontSize:8,fontWeight:FontWeight.bold)),Text(b,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:10,fontWeight:FontWeight.bold)),const Text('4 mnt baca • Tips & Inspirasi',style:TextStyle(color:muted,fontSize:8))]))]));
  Widget _sectionTitle(String title,String action)=>Row(children:[Expanded(child:Text(title,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w800))),TextButton(onPressed:()=>toast(action),child:Text(action,style:const TextStyle(fontSize:10,color:blue)))]);
  Widget _navBar()=>Container(height:58,decoration:BoxDecoration(color:surface,borderRadius:BorderRadius.circular(32),border:Border.all(color:line),boxShadow:[BoxShadow(color:ink.withValues(alpha:.1),blurRadius:17)]),child:Row(children:[_navItem(0,Icons.explore_outlined),_navItem(1,Icons.notifications_none),_navItem(2,Icons.bookmark_border),_navItem(3,Icons.person_outline)]));
  Widget _navItem(int i,IconData icon)=>Expanded(child:InkWell(onTap:(){setState(()=>nav=i);if(i==1)_notifications();if(i==2)toast('${saved.length} tempat tersimpan');if(i==3)toast('Profil Naufal');},child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(icon,color:nav==i?blue:muted),const SizedBox(height:4),Container(width:12,height:3,decoration:BoxDecoration(color:nav==i?blue:Colors.transparent,borderRadius:BorderRadius.circular(4)))])));
}
class _Benefit extends StatelessWidget{const _Benefit(this.text);final String text;@override Widget build(BuildContext context)=>SizedBox(width:145,child:Row(children:[const Icon(Icons.check_circle,color:Color(0xFF16A36A),size:15),const SizedBox(width:4),Expanded(child:Text(text,style:const TextStyle(fontSize:9,color:ink)))]));}
class _Tag extends StatelessWidget{const _Tag(this.text);final String text;@override Widget build(BuildContext context)=>Chip(label:Text(text),backgroundColor:bg,side:const BorderSide(color:line));}
