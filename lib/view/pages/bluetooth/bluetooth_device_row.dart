import 'package:bluez/bluez.dart';
import 'package:flutter/material.dart';
import 'package:settings/view/widgets/settings_row.dart';

class BluetoothDeviceRow extends StatefulWidget {
  const BluetoothDeviceRow({Key? key, required this.device}) : super(key: key);

  final BlueZDevice device;

  @override
  State<BluetoothDeviceRow> createState() => _BluetoothDeviceRowState();
}

class _BluetoothDeviceRowState extends State<BluetoothDeviceRow> {
  late String status;

  @override
  void initState() {
    status = widget.device.connected ? 'connected' : 'disconnected';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    status = widget.device.connected ? 'connected' : 'disconnected';
    return InkWell(
      borderRadius: BorderRadius.circular(4.0),
      onTap: () => setState(() {
        showSimpleDeviceDialog(context);
      }),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SettingsRow(
            trailingWidget: Text(widget.device.name),
            actionWidget: Text(
              widget.device.connected ? 'connected' : 'disconnected',
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            )),
      ),
    );
  }

  void showSimpleDeviceDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                  child: Text(widget.device.name),
                ),
                content: SizedBox(
                  height: 270,
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SettingsRow(
                            trailingWidget: widget.device.connected
                                ? const Text('Connected')
                                : const Text('Disconnected'),
                            actionWidget: Switch(
                                value: widget.device.connected,
                                onChanged: (newValue) async {
                                  widget.device.connected
                                      ? await widget.device.disconnect()
                                      : await widget.device
                                          .connect()
                                          .catchError((ioError) => {});
                                  setState(() {});
                                })),
                        SettingsRow(
                            trailingWidget: widget.device.paired
                                ? const Text('Paired')
                                : const Text('Unpaired'),
                            actionWidget: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(widget.device.paired ? 'Yes' : 'No'),
                            )),
                        SettingsRow(
                            trailingWidget: const Text('Address'),
                            actionWidget: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(widget.device.address),
                            )),
                        SettingsRow(
                            trailingWidget: const Text('Type'),
                            actionWidget: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(widget.device.appearance.toString()),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 8, right: 8, left: 8),
                          child: SizedBox(
                            width: 300,
                            child: OutlinedButton(
                                onPressed: () => print('open device settings'),
                                child: const Text('Open device settings')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: 300,
                            child: TextButton(
                                onPressed: () => print('remove'),
                                child: const Text('Remove device')),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })).then((value) => setState(() {}));
  }
}