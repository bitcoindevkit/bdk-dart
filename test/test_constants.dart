import 'package:bdk_dart/bdk.dart';

const testExtendedPrivKey =
    "tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B";
const bip84TestReceivePath = "84h/1h/0h/0";
const bip84TestChangePath = "84h/1h/0h/1";
const bip86TestReceivePath = "86h/1h/0h/0";
const bip86TestChangePath = "86h/1h/0h/1";

const mainnetExtendedPrivKey =
    "xprv9s21ZrQH143K3LRcTnWpaCSYb75ic2rGuSgicmJhSVQSbfaKgPXfa8PhnYszgdcyWLoc8n1E2iHUnskjgGTAyCEpJYv7fqKxUcRNaVngA1V";
const bip84MainnetReceivePath = "84h/0h/0h/1";
const bip86MainnetReceivePath = "86h/0h/0h/1";

const offlineDescriptorString =
    "wpkh(tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B/84h/1h/1h/0/*)";
const offlineChangeDescriptorString =
    "wpkh(tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B/84h/1h/1h/1/*)";

const persistenceDescriptorString =
    "wpkh(tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B/84h/1h/0h/0/*)";
const persistenceChangeDescriptorString =
    "wpkh(tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B/84h/1h/0h/1/*)";
const persistencePublicDescriptorString =
    "wpkh([9122d9e0/84'/1'/0']tpubDCYVtmaSaDzTxcgvoP5AHZNbZKZzrvoNH9KARep88vESc6MxRqAp4LmePc2eeGX6XUxBcdhAmkthWTDqygPz2wLAyHWisD299Lkdrj5egY6/0/*)#zpaanzgu";
const persistencePublicChangeDescriptorString =
    "wpkh([9122d9e0/84'/1'/0']tpubDCYVtmaSaDzTxcgvoP5AHZNbZKZzrvoNH9KARep88vESc6MxRqAp4LmePc2eeGX6XUxBcdhAmkthWTDqygPz2wLAyHWisD299Lkdrj5egY6/1/*)#n4cuwhcy";

const multipathDescriptorString =
    "wpkh([9a6a2580/84'/0'/0']xpub6DEzNop46vmxR49zYWFnMwmEfawSNmAMf6dLH5YKDY463twtvw1XD7ihwJRLPRGZJz799VPFzXHpZu6WdhT29WnaeuChS6aZHZPFmqczR5K/<0;1>/*)";
const privateMultipathDescriptorString =
    "tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B/<0;1>/*)";

const expectedOfflineAddress = "tb1qhjys9wxlfykmte7ftryptx975uqgd6kcm6a7z4";
const expectedPersistedAddress = "tb1qan3lldunh37ma6c0afeywgjyjgnyc8uz975zl2";

Descriptor buildDescriptor(String descriptor, Network network) =>
    Descriptor(descriptor: descriptor, network: network);

Descriptor buildBip84Descriptor(Network network) => Descriptor(
  descriptor: "wpkh($testExtendedPrivKey/$bip84TestReceivePath/*)",
  network: network,
);

Descriptor buildBip84ChangeDescriptor(Network network) => Descriptor(
  descriptor: "wpkh($testExtendedPrivKey/$bip84TestChangePath/*)",
  network: network,
);

Descriptor buildBip86Descriptor(Network network) => Descriptor(
  descriptor: "tr($testExtendedPrivKey/$bip86TestReceivePath/*)",
  network: network,
);

Descriptor buildBip86ChangeDescriptor(Network network) => Descriptor(
  descriptor: "tr($testExtendedPrivKey/$bip86TestChangePath/*)",
  network: network,
);

Descriptor buildMainnetBip84Descriptor() => Descriptor(
  descriptor: "wpkh($mainnetExtendedPrivKey/$bip84MainnetReceivePath/*)",
  network: Network.bitcoin,
);

Descriptor buildMainnetBip86Descriptor() => Descriptor(
  descriptor: "tr($mainnetExtendedPrivKey/$bip86MainnetReceivePath/*)",
  network: Network.bitcoin,
);

Descriptor buildNonExtendedDescriptor(int index) => Descriptor(
  descriptor: "wpkh($testExtendedPrivKey/$bip84TestReceivePath/$index)",
  network: Network.testnet,
);

const defaultLookahead = 25;
