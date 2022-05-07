import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomMapWidget extends StatefulWidget {
  const BottomMapWidget({Key? key}) : super(key: key);

  @override
  State<BottomMapWidget> createState() => _BottomMapWidgetState();
}

class _BottomMapWidgetState extends State<BottomMapWidget> {
  Map carType = {
    'name': 'All',
    'icon': FontAwesomeIcons.carAlt,
    'color': Colors.blueGrey
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  contentPadding: EdgeInsets.zero,
                  insetPadding: const EdgeInsets.all(25),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 15, 5),
                          child: Row(
                            children: [
                              const Text(
                                'Select Vehicle Type',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                        ),
                        MapVehicleDialog(
                          onSelected: (val) {
                            setState(() {
                              carType = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        width: size.width,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  carType['icon'],
                  color: carType['color'],
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carType['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      '660cc - 1000cc',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MapVehicleDialog extends StatefulWidget {
  const MapVehicleDialog({Key? key, this.onSelected}) : super(key: key);
  final Function(Map vehicle)? onSelected;

  @override
  State<MapVehicleDialog> createState() => _MapVehicleDialogState();
}

class _MapVehicleDialogState extends State<MapVehicleDialog> {
  List<Map> vehicleTypes = [
    {'name': 'All ', 'icon': FontAwesomeIcons.carAlt, 'color': Colors.blueGrey},
    {
      'name': 'Car',
      'icon': FontAwesomeIcons.car,
      'color': Colors.blue,
    },
    {
      'name': 'Bike',
      'icon': FontAwesomeIcons.biking,
      'color': Colors.green,
    },
    {
      'name': 'Truck',
      'icon': FontAwesomeIcons.truck,
      'color': Colors.orange,
    },
    {
      'name': 'Bus',
      'icon': FontAwesomeIcons.bus,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        children: List.generate(
          vehicleTypes.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                widget.onSelected!(vehicleTypes[index]);
              });
              Navigator.of(context).pop();
            },
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        vehicleTypes[index]['icon'],
                        color: vehicleTypes[index]['color'],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicleTypes[index]['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            '660cc - 1000cc',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
