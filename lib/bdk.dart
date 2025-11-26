library bdk_dart;

import "dart:async";
import "dart:convert";
import "dart:ffi";
import "dart:io" show Platform, File, Directory;
import "dart:isolate";
import "dart:typed_data";
import "package:ffi/ffi.dart";

class AddressInfo {
  final int index;
  final Address address;
  final KeychainKind keychain;
  AddressInfo(this.index, this.address, this.keychain);
}

class FfiConverterAddressInfo {
  static AddressInfo lift(RustBuffer buf) {
    return FfiConverterAddressInfo.read(buf.asUint8List()).value;
  }

  static LiftRetVal<AddressInfo> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final index_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final index = index_lifted.value;
    new_offset += index_lifted.bytesRead;
    final address_lifted = Address.read(Uint8List.view(buf.buffer, new_offset));
    final address = address_lifted.value;
    new_offset += address_lifted.bytesRead;
    final keychain_lifted = FfiConverterKeychainKind.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final keychain = keychain_lifted.value;
    new_offset += keychain_lifted.bytesRead;
    return LiftRetVal(
      AddressInfo(index, address, keychain),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(AddressInfo value) {
    final total_length =
        FfiConverterUInt32.allocationSize(value.index) +
        Address.allocationSize(value.address) +
        FfiConverterKeychainKind.allocationSize(value.keychain) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(AddressInfo value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUInt32.write(
      value.index,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Address.write(
      value.address,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterKeychainKind.write(
      value.keychain,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(AddressInfo value) {
    return FfiConverterUInt32.allocationSize(value.index) +
        Address.allocationSize(value.address) +
        FfiConverterKeychainKind.allocationSize(value.keychain) +
        0;
  }
}

class Anchor {
  final ConfirmationBlockTime confirmationBlockTime;
  final Txid txid;
  Anchor(this.confirmationBlockTime, this.txid);
}

class FfiConverterAnchor {
  static Anchor lift(RustBuffer buf) {
    return FfiConverterAnchor.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Anchor> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final confirmationBlockTime_lifted = FfiConverterConfirmationBlockTime.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final confirmationBlockTime = confirmationBlockTime_lifted.value;
    new_offset += confirmationBlockTime_lifted.bytesRead;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    return LiftRetVal(
      Anchor(confirmationBlockTime, txid),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(Anchor value) {
    final total_length =
        FfiConverterConfirmationBlockTime.allocationSize(
          value.confirmationBlockTime,
        ) +
        Txid.allocationSize(value.txid) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Anchor value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterConfirmationBlockTime.write(
      value.confirmationBlockTime,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Txid.write(
      value.txid,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Anchor value) {
    return FfiConverterConfirmationBlockTime.allocationSize(
          value.confirmationBlockTime,
        ) +
        Txid.allocationSize(value.txid) +
        0;
  }
}

class Balance {
  final Amount immature;
  final Amount trustedPending;
  final Amount untrustedPending;
  final Amount confirmed;
  final Amount trustedSpendable;
  final Amount total;
  Balance(
    this.immature,
    this.trustedPending,
    this.untrustedPending,
    this.confirmed,
    this.trustedSpendable,
    this.total,
  );
}

class FfiConverterBalance {
  static Balance lift(RustBuffer buf) {
    return FfiConverterBalance.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Balance> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final immature_lifted = Amount.read(Uint8List.view(buf.buffer, new_offset));
    final immature = immature_lifted.value;
    new_offset += immature_lifted.bytesRead;
    final trustedPending_lifted = Amount.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final trustedPending = trustedPending_lifted.value;
    new_offset += trustedPending_lifted.bytesRead;
    final untrustedPending_lifted = Amount.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final untrustedPending = untrustedPending_lifted.value;
    new_offset += untrustedPending_lifted.bytesRead;
    final confirmed_lifted = Amount.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final confirmed = confirmed_lifted.value;
    new_offset += confirmed_lifted.bytesRead;
    final trustedSpendable_lifted = Amount.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final trustedSpendable = trustedSpendable_lifted.value;
    new_offset += trustedSpendable_lifted.bytesRead;
    final total_lifted = Amount.read(Uint8List.view(buf.buffer, new_offset));
    final total = total_lifted.value;
    new_offset += total_lifted.bytesRead;
    return LiftRetVal(
      Balance(
        immature,
        trustedPending,
        untrustedPending,
        confirmed,
        trustedSpendable,
        total,
      ),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(Balance value) {
    final total_length =
        Amount.allocationSize(value.immature) +
        Amount.allocationSize(value.trustedPending) +
        Amount.allocationSize(value.untrustedPending) +
        Amount.allocationSize(value.confirmed) +
        Amount.allocationSize(value.trustedSpendable) +
        Amount.allocationSize(value.total) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Balance value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Amount.write(
      value.immature,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.trustedPending,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.untrustedPending,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.confirmed,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.trustedSpendable,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.total,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Balance value) {
    return Amount.allocationSize(value.immature) +
        Amount.allocationSize(value.trustedPending) +
        Amount.allocationSize(value.untrustedPending) +
        Amount.allocationSize(value.confirmed) +
        Amount.allocationSize(value.trustedSpendable) +
        Amount.allocationSize(value.total) +
        0;
  }
}

class BlockId {
  final int height;
  final BlockHash hash;
  BlockId(this.height, this.hash);
}

class FfiConverterBlockId {
  static BlockId lift(RustBuffer buf) {
    return FfiConverterBlockId.read(buf.asUint8List()).value;
  }

  static LiftRetVal<BlockId> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final height_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final height = height_lifted.value;
    new_offset += height_lifted.bytesRead;
    final hash_lifted = BlockHash.read(Uint8List.view(buf.buffer, new_offset));
    final hash = hash_lifted.value;
    new_offset += hash_lifted.bytesRead;
    return LiftRetVal(BlockId(height, hash), new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(BlockId value) {
    final total_length =
        FfiConverterUInt32.allocationSize(value.height) +
        BlockHash.allocationSize(value.hash) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(BlockId value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUInt32.write(
      value.height,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += BlockHash.write(
      value.hash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(BlockId value) {
    return FfiConverterUInt32.allocationSize(value.height) +
        BlockHash.allocationSize(value.hash) +
        0;
  }
}

class CanonicalTx {
  final Transaction transaction;
  final ChainPosition chainPosition;
  CanonicalTx(this.transaction, this.chainPosition);
}

class FfiConverterCanonicalTx {
  static CanonicalTx lift(RustBuffer buf) {
    return FfiConverterCanonicalTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<CanonicalTx> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final transaction_lifted = Transaction.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final transaction = transaction_lifted.value;
    new_offset += transaction_lifted.bytesRead;
    final chainPosition_lifted = FfiConverterChainPosition.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final chainPosition = chainPosition_lifted.value;
    new_offset += chainPosition_lifted.bytesRead;
    return LiftRetVal(
      CanonicalTx(transaction, chainPosition),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(CanonicalTx value) {
    final total_length =
        Transaction.allocationSize(value.transaction) +
        FfiConverterChainPosition.allocationSize(value.chainPosition) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(CanonicalTx value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Transaction.write(
      value.transaction,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterChainPosition.write(
      value.chainPosition,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(CanonicalTx value) {
    return Transaction.allocationSize(value.transaction) +
        FfiConverterChainPosition.allocationSize(value.chainPosition) +
        0;
  }
}

class CbfComponents {
  final CbfClient client;
  final CbfNode node;
  CbfComponents(this.client, this.node);
}

class FfiConverterCbfComponents {
  static CbfComponents lift(RustBuffer buf) {
    return FfiConverterCbfComponents.read(buf.asUint8List()).value;
  }

  static LiftRetVal<CbfComponents> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final client_lifted = CbfClient.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final client = client_lifted.value;
    new_offset += client_lifted.bytesRead;
    final node_lifted = CbfNode.read(Uint8List.view(buf.buffer, new_offset));
    final node = node_lifted.value;
    new_offset += node_lifted.bytesRead;
    return LiftRetVal(
      CbfComponents(client, node),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(CbfComponents value) {
    final total_length =
        CbfClient.allocationSize(value.client) +
        CbfNode.allocationSize(value.node) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(CbfComponents value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += CbfClient.write(
      value.client,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += CbfNode.write(
      value.node,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(CbfComponents value) {
    return CbfClient.allocationSize(value.client) +
        CbfNode.allocationSize(value.node) +
        0;
  }
}

class ChainChange {
  final int height;
  final BlockHash? hash;
  ChainChange(this.height, this.hash);
}

class FfiConverterChainChange {
  static ChainChange lift(RustBuffer buf) {
    return FfiConverterChainChange.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ChainChange> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final height_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final height = height_lifted.value;
    new_offset += height_lifted.bytesRead;
    final hash_lifted = FfiConverterOptionalBlockHash.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hash = hash_lifted.value;
    new_offset += hash_lifted.bytesRead;
    return LiftRetVal(
      ChainChange(height, hash),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(ChainChange value) {
    final total_length =
        FfiConverterUInt32.allocationSize(value.height) +
        FfiConverterOptionalBlockHash.allocationSize(value.hash) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ChainChange value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUInt32.write(
      value.height,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalBlockHash.write(
      value.hash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ChainChange value) {
    return FfiConverterUInt32.allocationSize(value.height) +
        FfiConverterOptionalBlockHash.allocationSize(value.hash) +
        0;
  }
}

class Condition {
  final int? csv;
  final LockTime? timelock;
  Condition(this.csv, this.timelock);
}

class FfiConverterCondition {
  static Condition lift(RustBuffer buf) {
    return FfiConverterCondition.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Condition> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final csv_lifted = FfiConverterOptionalUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final csv = csv_lifted.value;
    new_offset += csv_lifted.bytesRead;
    final timelock_lifted = FfiConverterOptionalLockTime.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final timelock = timelock_lifted.value;
    new_offset += timelock_lifted.bytesRead;
    return LiftRetVal(Condition(csv, timelock), new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(Condition value) {
    final total_length =
        FfiConverterOptionalUInt32.allocationSize(value.csv) +
        FfiConverterOptionalLockTime.allocationSize(value.timelock) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Condition value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalUInt32.write(
      value.csv,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalLockTime.write(
      value.timelock,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Condition value) {
    return FfiConverterOptionalUInt32.allocationSize(value.csv) +
        FfiConverterOptionalLockTime.allocationSize(value.timelock) +
        0;
  }
}

class ConfirmationBlockTime {
  final BlockId blockId;
  final int confirmationTime;
  ConfirmationBlockTime(this.blockId, this.confirmationTime);
}

class FfiConverterConfirmationBlockTime {
  static ConfirmationBlockTime lift(RustBuffer buf) {
    return FfiConverterConfirmationBlockTime.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ConfirmationBlockTime> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final blockId_lifted = FfiConverterBlockId.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final blockId = blockId_lifted.value;
    new_offset += blockId_lifted.bytesRead;
    final confirmationTime_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final confirmationTime = confirmationTime_lifted.value;
    new_offset += confirmationTime_lifted.bytesRead;
    return LiftRetVal(
      ConfirmationBlockTime(blockId, confirmationTime),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(ConfirmationBlockTime value) {
    final total_length =
        FfiConverterBlockId.allocationSize(value.blockId) +
        FfiConverterUInt64.allocationSize(value.confirmationTime) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ConfirmationBlockTime value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterBlockId.write(
      value.blockId,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      value.confirmationTime,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ConfirmationBlockTime value) {
    return FfiConverterBlockId.allocationSize(value.blockId) +
        FfiConverterUInt64.allocationSize(value.confirmationTime) +
        0;
  }
}

class Conflict {
  final int vin;
  final Txid txid;
  Conflict(this.vin, this.txid);
}

class FfiConverterConflict {
  static Conflict lift(RustBuffer buf) {
    return FfiConverterConflict.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Conflict> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final vin_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final vin = vin_lifted.value;
    new_offset += vin_lifted.bytesRead;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    return LiftRetVal(Conflict(vin, txid), new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(Conflict value) {
    final total_length =
        FfiConverterUInt32.allocationSize(value.vin) +
        Txid.allocationSize(value.txid) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Conflict value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUInt32.write(
      value.vin,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Txid.write(
      value.txid,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Conflict value) {
    return FfiConverterUInt32.allocationSize(value.vin) +
        Txid.allocationSize(value.txid) +
        0;
  }
}

class ControlBlock {
  final Uint8List internalKey;
  final List<String> merkleBranch;
  final int outputKeyParity;
  final int leafVersion;
  ControlBlock(
    this.internalKey,
    this.merkleBranch,
    this.outputKeyParity,
    this.leafVersion,
  );
}

class FfiConverterControlBlock {
  static ControlBlock lift(RustBuffer buf) {
    return FfiConverterControlBlock.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ControlBlock> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final internalKey_lifted = FfiConverterUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final internalKey = internalKey_lifted.value;
    new_offset += internalKey_lifted.bytesRead;
    final merkleBranch_lifted = FfiConverterSequenceString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final merkleBranch = merkleBranch_lifted.value;
    new_offset += merkleBranch_lifted.bytesRead;
    final outputKeyParity_lifted = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final outputKeyParity = outputKeyParity_lifted.value;
    new_offset += outputKeyParity_lifted.bytesRead;
    final leafVersion_lifted = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final leafVersion = leafVersion_lifted.value;
    new_offset += leafVersion_lifted.bytesRead;
    return LiftRetVal(
      ControlBlock(internalKey, merkleBranch, outputKeyParity, leafVersion),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(ControlBlock value) {
    final total_length =
        FfiConverterUint8List.allocationSize(value.internalKey) +
        FfiConverterSequenceString.allocationSize(value.merkleBranch) +
        FfiConverterUInt8.allocationSize(value.outputKeyParity) +
        FfiConverterUInt8.allocationSize(value.leafVersion) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ControlBlock value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUint8List.write(
      value.internalKey,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterSequenceString.write(
      value.merkleBranch,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt8.write(
      value.outputKeyParity,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt8.write(
      value.leafVersion,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ControlBlock value) {
    return FfiConverterUint8List.allocationSize(value.internalKey) +
        FfiConverterSequenceString.allocationSize(value.merkleBranch) +
        FfiConverterUInt8.allocationSize(value.outputKeyParity) +
        FfiConverterUInt8.allocationSize(value.leafVersion) +
        0;
  }
}

class EvictedTx {
  final Txid txid;
  final int evictedAt;
  EvictedTx(this.txid, this.evictedAt);
}

class FfiConverterEvictedTx {
  static EvictedTx lift(RustBuffer buf) {
    return FfiConverterEvictedTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<EvictedTx> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    final evictedAt_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final evictedAt = evictedAt_lifted.value;
    new_offset += evictedAt_lifted.bytesRead;
    return LiftRetVal(
      EvictedTx(txid, evictedAt),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(EvictedTx value) {
    final total_length =
        Txid.allocationSize(value.txid) +
        FfiConverterUInt64.allocationSize(value.evictedAt) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(EvictedTx value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Txid.write(
      value.txid,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      value.evictedAt,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(EvictedTx value) {
    return Txid.allocationSize(value.txid) +
        FfiConverterUInt64.allocationSize(value.evictedAt) +
        0;
  }
}

class FinalizedPsbtResult {
  final Psbt psbt;
  final bool couldFinalize;
  final List<PsbtFinalizeException>? errors;
  FinalizedPsbtResult(this.psbt, this.couldFinalize, this.errors);
}

class FfiConverterFinalizedPsbtResult {
  static FinalizedPsbtResult lift(RustBuffer buf) {
    return FfiConverterFinalizedPsbtResult.read(buf.asUint8List()).value;
  }

  static LiftRetVal<FinalizedPsbtResult> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final psbt_lifted = Psbt.read(Uint8List.view(buf.buffer, new_offset));
    final psbt = psbt_lifted.value;
    new_offset += psbt_lifted.bytesRead;
    final couldFinalize_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final couldFinalize = couldFinalize_lifted.value;
    new_offset += couldFinalize_lifted.bytesRead;
    final errors_lifted =
        FfiConverterOptionalSequencePsbtFinalizeException.read(
          Uint8List.view(buf.buffer, new_offset),
        );
    final errors = errors_lifted.value;
    new_offset += errors_lifted.bytesRead;
    return LiftRetVal(
      FinalizedPsbtResult(psbt, couldFinalize, errors),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(FinalizedPsbtResult value) {
    final total_length =
        Psbt.allocationSize(value.psbt) +
        FfiConverterBool.allocationSize(value.couldFinalize) +
        FfiConverterOptionalSequencePsbtFinalizeException.allocationSize(
          value.errors,
        ) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(FinalizedPsbtResult value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Psbt.write(
      value.psbt,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterBool.write(
      value.couldFinalize,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalSequencePsbtFinalizeException.write(
      value.errors,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(FinalizedPsbtResult value) {
    return Psbt.allocationSize(value.psbt) +
        FfiConverterBool.allocationSize(value.couldFinalize) +
        FfiConverterOptionalSequencePsbtFinalizeException.allocationSize(
          value.errors,
        ) +
        0;
  }
}

class Header {
  final int version;
  final BlockHash prevBlockhash;
  final TxMerkleNode merkleRoot;
  final int time;
  final int bits;
  final int nonce;
  Header(
    this.version,
    this.prevBlockhash,
    this.merkleRoot,
    this.time,
    this.bits,
    this.nonce,
  );
}

class FfiConverterHeader {
  static Header lift(RustBuffer buf) {
    return FfiConverterHeader.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Header> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final version_lifted = FfiConverterInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final version = version_lifted.value;
    new_offset += version_lifted.bytesRead;
    final prevBlockhash_lifted = BlockHash.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final prevBlockhash = prevBlockhash_lifted.value;
    new_offset += prevBlockhash_lifted.bytesRead;
    final merkleRoot_lifted = TxMerkleNode.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final merkleRoot = merkleRoot_lifted.value;
    new_offset += merkleRoot_lifted.bytesRead;
    final time_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final time = time_lifted.value;
    new_offset += time_lifted.bytesRead;
    final bits_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final bits = bits_lifted.value;
    new_offset += bits_lifted.bytesRead;
    final nonce_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final nonce = nonce_lifted.value;
    new_offset += nonce_lifted.bytesRead;
    return LiftRetVal(
      Header(version, prevBlockhash, merkleRoot, time, bits, nonce),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(Header value) {
    final total_length =
        FfiConverterInt32.allocationSize(value.version) +
        BlockHash.allocationSize(value.prevBlockhash) +
        TxMerkleNode.allocationSize(value.merkleRoot) +
        FfiConverterUInt32.allocationSize(value.time) +
        FfiConverterUInt32.allocationSize(value.bits) +
        FfiConverterUInt32.allocationSize(value.nonce) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Header value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterInt32.write(
      value.version,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += BlockHash.write(
      value.prevBlockhash,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += TxMerkleNode.write(
      value.merkleRoot,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      value.time,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      value.bits,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      value.nonce,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Header value) {
    return FfiConverterInt32.allocationSize(value.version) +
        BlockHash.allocationSize(value.prevBlockhash) +
        TxMerkleNode.allocationSize(value.merkleRoot) +
        FfiConverterUInt32.allocationSize(value.time) +
        FfiConverterUInt32.allocationSize(value.bits) +
        FfiConverterUInt32.allocationSize(value.nonce) +
        0;
  }
}

class HeaderNotification {
  final int height;
  final Header header;
  HeaderNotification(this.height, this.header);
}

class FfiConverterHeaderNotification {
  static HeaderNotification lift(RustBuffer buf) {
    return FfiConverterHeaderNotification.read(buf.asUint8List()).value;
  }

  static LiftRetVal<HeaderNotification> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final height_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final height = height_lifted.value;
    new_offset += height_lifted.bytesRead;
    final header_lifted = FfiConverterHeader.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final header = header_lifted.value;
    new_offset += header_lifted.bytesRead;
    return LiftRetVal(
      HeaderNotification(height, header),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(HeaderNotification value) {
    final total_length =
        FfiConverterUInt64.allocationSize(value.height) +
        FfiConverterHeader.allocationSize(value.header) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(HeaderNotification value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUInt64.write(
      value.height,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterHeader.write(
      value.header,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(HeaderNotification value) {
    return FfiConverterUInt64.allocationSize(value.height) +
        FfiConverterHeader.allocationSize(value.header) +
        0;
  }
}

class IndexerChangeSet {
  final Map<DescriptorId, int> lastRevealed;
  IndexerChangeSet(this.lastRevealed);
}

class FfiConverterIndexerChangeSet {
  static IndexerChangeSet lift(RustBuffer buf) {
    return FfiConverterIndexerChangeSet.read(buf.asUint8List()).value;
  }

  static LiftRetVal<IndexerChangeSet> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final lastRevealed_lifted = FfiConverterMapDescriptorIdToUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final lastRevealed = lastRevealed_lifted.value;
    new_offset += lastRevealed_lifted.bytesRead;
    return LiftRetVal(
      IndexerChangeSet(lastRevealed),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(IndexerChangeSet value) {
    final total_length =
        FfiConverterMapDescriptorIdToUInt32.allocationSize(value.lastRevealed) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(IndexerChangeSet value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterMapDescriptorIdToUInt32.write(
      value.lastRevealed,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(IndexerChangeSet value) {
    return FfiConverterMapDescriptorIdToUInt32.allocationSize(
          value.lastRevealed,
        ) +
        0;
  }
}

class Input {
  final Transaction? nonWitnessUtxo;
  final TxOut? witnessUtxo;
  final Map<String, Uint8List> partialSigs;
  final String? sighashType;
  final Script? redeemScript;
  final Script? witnessScript;
  final Map<String, KeySource> bip32Derivation;
  final Script? finalScriptSig;
  final List<Uint8List>? finalScriptWitness;
  final Map<String, Uint8List> ripemd160Preimages;
  final Map<String, Uint8List> sha256Preimages;
  final Map<String, Uint8List> hash160Preimages;
  final Map<String, Uint8List> hash256Preimages;
  final Uint8List? tapKeySig;
  final Map<TapScriptSigKey, Uint8List> tapScriptSigs;
  final Map<ControlBlock, TapScriptEntry> tapScripts;
  final Map<String, TapKeyOrigin> tapKeyOrigins;
  final String? tapInternalKey;
  final String? tapMerkleRoot;
  final Map<ProprietaryKey, Uint8List> proprietary;
  final Map<Key, Uint8List> unknown;
  Input(
    this.nonWitnessUtxo,
    this.witnessUtxo,
    this.partialSigs,
    this.sighashType,
    this.redeemScript,
    this.witnessScript,
    this.bip32Derivation,
    this.finalScriptSig,
    this.finalScriptWitness,
    this.ripemd160Preimages,
    this.sha256Preimages,
    this.hash160Preimages,
    this.hash256Preimages,
    this.tapKeySig,
    this.tapScriptSigs,
    this.tapScripts,
    this.tapKeyOrigins,
    this.tapInternalKey,
    this.tapMerkleRoot,
    this.proprietary,
    this.unknown,
  );
}

class FfiConverterInput {
  static Input lift(RustBuffer buf) {
    return FfiConverterInput.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Input> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final nonWitnessUtxo_lifted = FfiConverterOptionalTransaction.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final nonWitnessUtxo = nonWitnessUtxo_lifted.value;
    new_offset += nonWitnessUtxo_lifted.bytesRead;
    final witnessUtxo_lifted = FfiConverterOptionalTxOut.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final witnessUtxo = witnessUtxo_lifted.value;
    new_offset += witnessUtxo_lifted.bytesRead;
    final partialSigs_lifted = FfiConverterMapStringToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final partialSigs = partialSigs_lifted.value;
    new_offset += partialSigs_lifted.bytesRead;
    final sighashType_lifted = FfiConverterOptionalString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final sighashType = sighashType_lifted.value;
    new_offset += sighashType_lifted.bytesRead;
    final redeemScript_lifted = FfiConverterOptionalScript.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final redeemScript = redeemScript_lifted.value;
    new_offset += redeemScript_lifted.bytesRead;
    final witnessScript_lifted = FfiConverterOptionalScript.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final witnessScript = witnessScript_lifted.value;
    new_offset += witnessScript_lifted.bytesRead;
    final bip32Derivation_lifted = FfiConverterMapStringToKeySource.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final bip32Derivation = bip32Derivation_lifted.value;
    new_offset += bip32Derivation_lifted.bytesRead;
    final finalScriptSig_lifted = FfiConverterOptionalScript.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final finalScriptSig = finalScriptSig_lifted.value;
    new_offset += finalScriptSig_lifted.bytesRead;
    final finalScriptWitness_lifted =
        FfiConverterOptionalSequenceUint8List.read(
          Uint8List.view(buf.buffer, new_offset),
        );
    final finalScriptWitness = finalScriptWitness_lifted.value;
    new_offset += finalScriptWitness_lifted.bytesRead;
    final ripemd160Preimages_lifted = FfiConverterMapStringToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final ripemd160Preimages = ripemd160Preimages_lifted.value;
    new_offset += ripemd160Preimages_lifted.bytesRead;
    final sha256Preimages_lifted = FfiConverterMapStringToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final sha256Preimages = sha256Preimages_lifted.value;
    new_offset += sha256Preimages_lifted.bytesRead;
    final hash160Preimages_lifted = FfiConverterMapStringToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hash160Preimages = hash160Preimages_lifted.value;
    new_offset += hash160Preimages_lifted.bytesRead;
    final hash256Preimages_lifted = FfiConverterMapStringToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hash256Preimages = hash256Preimages_lifted.value;
    new_offset += hash256Preimages_lifted.bytesRead;
    final tapKeySig_lifted = FfiConverterOptionalUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapKeySig = tapKeySig_lifted.value;
    new_offset += tapKeySig_lifted.bytesRead;
    final tapScriptSigs_lifted = FfiConverterMapTapScriptSigKeyToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapScriptSigs = tapScriptSigs_lifted.value;
    new_offset += tapScriptSigs_lifted.bytesRead;
    final tapScripts_lifted = FfiConverterMapControlBlockToTapScriptEntry.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapScripts = tapScripts_lifted.value;
    new_offset += tapScripts_lifted.bytesRead;
    final tapKeyOrigins_lifted = FfiConverterMapStringToTapKeyOrigin.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapKeyOrigins = tapKeyOrigins_lifted.value;
    new_offset += tapKeyOrigins_lifted.bytesRead;
    final tapInternalKey_lifted = FfiConverterOptionalString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapInternalKey = tapInternalKey_lifted.value;
    new_offset += tapInternalKey_lifted.bytesRead;
    final tapMerkleRoot_lifted = FfiConverterOptionalString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapMerkleRoot = tapMerkleRoot_lifted.value;
    new_offset += tapMerkleRoot_lifted.bytesRead;
    final proprietary_lifted = FfiConverterMapProprietaryKeyToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final proprietary = proprietary_lifted.value;
    new_offset += proprietary_lifted.bytesRead;
    final unknown_lifted = FfiConverterMapKeyToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final unknown = unknown_lifted.value;
    new_offset += unknown_lifted.bytesRead;
    return LiftRetVal(
      Input(
        nonWitnessUtxo,
        witnessUtxo,
        partialSigs,
        sighashType,
        redeemScript,
        witnessScript,
        bip32Derivation,
        finalScriptSig,
        finalScriptWitness,
        ripemd160Preimages,
        sha256Preimages,
        hash160Preimages,
        hash256Preimages,
        tapKeySig,
        tapScriptSigs,
        tapScripts,
        tapKeyOrigins,
        tapInternalKey,
        tapMerkleRoot,
        proprietary,
        unknown,
      ),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(Input value) {
    final total_length =
        FfiConverterOptionalTransaction.allocationSize(value.nonWitnessUtxo) +
        FfiConverterOptionalTxOut.allocationSize(value.witnessUtxo) +
        FfiConverterMapStringToUint8List.allocationSize(value.partialSigs) +
        FfiConverterOptionalString.allocationSize(value.sighashType) +
        FfiConverterOptionalScript.allocationSize(value.redeemScript) +
        FfiConverterOptionalScript.allocationSize(value.witnessScript) +
        FfiConverterMapStringToKeySource.allocationSize(value.bip32Derivation) +
        FfiConverterOptionalScript.allocationSize(value.finalScriptSig) +
        FfiConverterOptionalSequenceUint8List.allocationSize(
          value.finalScriptWitness,
        ) +
        FfiConverterMapStringToUint8List.allocationSize(
          value.ripemd160Preimages,
        ) +
        FfiConverterMapStringToUint8List.allocationSize(value.sha256Preimages) +
        FfiConverterMapStringToUint8List.allocationSize(
          value.hash160Preimages,
        ) +
        FfiConverterMapStringToUint8List.allocationSize(
          value.hash256Preimages,
        ) +
        FfiConverterOptionalUint8List.allocationSize(value.tapKeySig) +
        FfiConverterMapTapScriptSigKeyToUint8List.allocationSize(
          value.tapScriptSigs,
        ) +
        FfiConverterMapControlBlockToTapScriptEntry.allocationSize(
          value.tapScripts,
        ) +
        FfiConverterMapStringToTapKeyOrigin.allocationSize(
          value.tapKeyOrigins,
        ) +
        FfiConverterOptionalString.allocationSize(value.tapInternalKey) +
        FfiConverterOptionalString.allocationSize(value.tapMerkleRoot) +
        FfiConverterMapProprietaryKeyToUint8List.allocationSize(
          value.proprietary,
        ) +
        FfiConverterMapKeyToUint8List.allocationSize(value.unknown) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Input value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalTransaction.write(
      value.nonWitnessUtxo,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalTxOut.write(
      value.witnessUtxo,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToUint8List.write(
      value.partialSigs,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalString.write(
      value.sighashType,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalScript.write(
      value.redeemScript,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalScript.write(
      value.witnessScript,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToKeySource.write(
      value.bip32Derivation,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalScript.write(
      value.finalScriptSig,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalSequenceUint8List.write(
      value.finalScriptWitness,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToUint8List.write(
      value.ripemd160Preimages,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToUint8List.write(
      value.sha256Preimages,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToUint8List.write(
      value.hash160Preimages,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToUint8List.write(
      value.hash256Preimages,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalUint8List.write(
      value.tapKeySig,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapTapScriptSigKeyToUint8List.write(
      value.tapScriptSigs,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapControlBlockToTapScriptEntry.write(
      value.tapScripts,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToTapKeyOrigin.write(
      value.tapKeyOrigins,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalString.write(
      value.tapInternalKey,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalString.write(
      value.tapMerkleRoot,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapProprietaryKeyToUint8List.write(
      value.proprietary,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapKeyToUint8List.write(
      value.unknown,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Input value) {
    return FfiConverterOptionalTransaction.allocationSize(
          value.nonWitnessUtxo,
        ) +
        FfiConverterOptionalTxOut.allocationSize(value.witnessUtxo) +
        FfiConverterMapStringToUint8List.allocationSize(value.partialSigs) +
        FfiConverterOptionalString.allocationSize(value.sighashType) +
        FfiConverterOptionalScript.allocationSize(value.redeemScript) +
        FfiConverterOptionalScript.allocationSize(value.witnessScript) +
        FfiConverterMapStringToKeySource.allocationSize(value.bip32Derivation) +
        FfiConverterOptionalScript.allocationSize(value.finalScriptSig) +
        FfiConverterOptionalSequenceUint8List.allocationSize(
          value.finalScriptWitness,
        ) +
        FfiConverterMapStringToUint8List.allocationSize(
          value.ripemd160Preimages,
        ) +
        FfiConverterMapStringToUint8List.allocationSize(value.sha256Preimages) +
        FfiConverterMapStringToUint8List.allocationSize(
          value.hash160Preimages,
        ) +
        FfiConverterMapStringToUint8List.allocationSize(
          value.hash256Preimages,
        ) +
        FfiConverterOptionalUint8List.allocationSize(value.tapKeySig) +
        FfiConverterMapTapScriptSigKeyToUint8List.allocationSize(
          value.tapScriptSigs,
        ) +
        FfiConverterMapControlBlockToTapScriptEntry.allocationSize(
          value.tapScripts,
        ) +
        FfiConverterMapStringToTapKeyOrigin.allocationSize(
          value.tapKeyOrigins,
        ) +
        FfiConverterOptionalString.allocationSize(value.tapInternalKey) +
        FfiConverterOptionalString.allocationSize(value.tapMerkleRoot) +
        FfiConverterMapProprietaryKeyToUint8List.allocationSize(
          value.proprietary,
        ) +
        FfiConverterMapKeyToUint8List.allocationSize(value.unknown) +
        0;
  }
}

class Key {
  final int typeValue;
  final Uint8List key;
  Key(this.typeValue, this.key);
}

class FfiConverterKey {
  static Key lift(RustBuffer buf) {
    return FfiConverterKey.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Key> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final typeValue_lifted = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final typeValue = typeValue_lifted.value;
    new_offset += typeValue_lifted.bytesRead;
    final key_lifted = FfiConverterUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final key = key_lifted.value;
    new_offset += key_lifted.bytesRead;
    return LiftRetVal(Key(typeValue, key), new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(Key value) {
    final total_length =
        FfiConverterUInt8.allocationSize(value.typeValue) +
        FfiConverterUint8List.allocationSize(value.key) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Key value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUInt8.write(
      value.typeValue,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUint8List.write(
      value.key,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Key value) {
    return FfiConverterUInt8.allocationSize(value.typeValue) +
        FfiConverterUint8List.allocationSize(value.key) +
        0;
  }
}

class KeySource {
  final String fingerprint;
  final DerivationPath path;
  KeySource(this.fingerprint, this.path);
}

class FfiConverterKeySource {
  static KeySource lift(RustBuffer buf) {
    return FfiConverterKeySource.read(buf.asUint8List()).value;
  }

  static LiftRetVal<KeySource> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final fingerprint_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final fingerprint = fingerprint_lifted.value;
    new_offset += fingerprint_lifted.bytesRead;
    final path_lifted = DerivationPath.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final path = path_lifted.value;
    new_offset += path_lifted.bytesRead;
    return LiftRetVal(
      KeySource(fingerprint, path),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(KeySource value) {
    final total_length =
        FfiConverterString.allocationSize(value.fingerprint) +
        DerivationPath.allocationSize(value.path) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(KeySource value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
      value.fingerprint,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += DerivationPath.write(
      value.path,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(KeySource value) {
    return FfiConverterString.allocationSize(value.fingerprint) +
        DerivationPath.allocationSize(value.path) +
        0;
  }
}

class KeychainAndIndex {
  final KeychainKind keychain;
  final int index;
  KeychainAndIndex(this.keychain, this.index);
}

class FfiConverterKeychainAndIndex {
  static KeychainAndIndex lift(RustBuffer buf) {
    return FfiConverterKeychainAndIndex.read(buf.asUint8List()).value;
  }

  static LiftRetVal<KeychainAndIndex> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final keychain_lifted = FfiConverterKeychainKind.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final keychain = keychain_lifted.value;
    new_offset += keychain_lifted.bytesRead;
    final index_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final index = index_lifted.value;
    new_offset += index_lifted.bytesRead;
    return LiftRetVal(
      KeychainAndIndex(keychain, index),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(KeychainAndIndex value) {
    final total_length =
        FfiConverterKeychainKind.allocationSize(value.keychain) +
        FfiConverterUInt32.allocationSize(value.index) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(KeychainAndIndex value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterKeychainKind.write(
      value.keychain,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      value.index,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(KeychainAndIndex value) {
    return FfiConverterKeychainKind.allocationSize(value.keychain) +
        FfiConverterUInt32.allocationSize(value.index) +
        0;
  }
}

class LocalChainChangeSet {
  final List<ChainChange> changes;
  LocalChainChangeSet(this.changes);
}

class FfiConverterLocalChainChangeSet {
  static LocalChainChangeSet lift(RustBuffer buf) {
    return FfiConverterLocalChainChangeSet.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LocalChainChangeSet> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final changes_lifted = FfiConverterSequenceChainChange.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final changes = changes_lifted.value;
    new_offset += changes_lifted.bytesRead;
    return LiftRetVal(
      LocalChainChangeSet(changes),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(LocalChainChangeSet value) {
    final total_length =
        FfiConverterSequenceChainChange.allocationSize(value.changes) + 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LocalChainChangeSet value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceChainChange.write(
      value.changes,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LocalChainChangeSet value) {
    return FfiConverterSequenceChainChange.allocationSize(value.changes) + 0;
  }
}

class LocalOutput {
  final OutPoint outpoint;
  final TxOut txout;
  final KeychainKind keychain;
  final bool isSpent;
  final int derivationIndex;
  final ChainPosition chainPosition;
  LocalOutput(
    this.outpoint,
    this.txout,
    this.keychain,
    this.isSpent,
    this.derivationIndex,
    this.chainPosition,
  );
}

class FfiConverterLocalOutput {
  static LocalOutput lift(RustBuffer buf) {
    return FfiConverterLocalOutput.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LocalOutput> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final outpoint_lifted = FfiConverterOutPoint.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final outpoint = outpoint_lifted.value;
    new_offset += outpoint_lifted.bytesRead;
    final txout_lifted = FfiConverterTxOut.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final txout = txout_lifted.value;
    new_offset += txout_lifted.bytesRead;
    final keychain_lifted = FfiConverterKeychainKind.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final keychain = keychain_lifted.value;
    new_offset += keychain_lifted.bytesRead;
    final isSpent_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final isSpent = isSpent_lifted.value;
    new_offset += isSpent_lifted.bytesRead;
    final derivationIndex_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final derivationIndex = derivationIndex_lifted.value;
    new_offset += derivationIndex_lifted.bytesRead;
    final chainPosition_lifted = FfiConverterChainPosition.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final chainPosition = chainPosition_lifted.value;
    new_offset += chainPosition_lifted.bytesRead;
    return LiftRetVal(
      LocalOutput(
        outpoint,
        txout,
        keychain,
        isSpent,
        derivationIndex,
        chainPosition,
      ),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(LocalOutput value) {
    final total_length =
        FfiConverterOutPoint.allocationSize(value.outpoint) +
        FfiConverterTxOut.allocationSize(value.txout) +
        FfiConverterKeychainKind.allocationSize(value.keychain) +
        FfiConverterBool.allocationSize(value.isSpent) +
        FfiConverterUInt32.allocationSize(value.derivationIndex) +
        FfiConverterChainPosition.allocationSize(value.chainPosition) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LocalOutput value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOutPoint.write(
      value.outpoint,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterTxOut.write(
      value.txout,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterKeychainKind.write(
      value.keychain,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterBool.write(
      value.isSpent,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      value.derivationIndex,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterChainPosition.write(
      value.chainPosition,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LocalOutput value) {
    return FfiConverterOutPoint.allocationSize(value.outpoint) +
        FfiConverterTxOut.allocationSize(value.txout) +
        FfiConverterKeychainKind.allocationSize(value.keychain) +
        FfiConverterBool.allocationSize(value.isSpent) +
        FfiConverterUInt32.allocationSize(value.derivationIndex) +
        FfiConverterChainPosition.allocationSize(value.chainPosition) +
        0;
  }
}

class OutPoint {
  final Txid txid;
  final int vout;
  OutPoint(this.txid, this.vout);
}

class FfiConverterOutPoint {
  static OutPoint lift(RustBuffer buf) {
    return FfiConverterOutPoint.read(buf.asUint8List()).value;
  }

  static LiftRetVal<OutPoint> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    final vout_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final vout = vout_lifted.value;
    new_offset += vout_lifted.bytesRead;
    return LiftRetVal(OutPoint(txid, vout), new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(OutPoint value) {
    final total_length =
        Txid.allocationSize(value.txid) +
        FfiConverterUInt32.allocationSize(value.vout) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(OutPoint value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Txid.write(
      value.txid,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      value.vout,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(OutPoint value) {
    return Txid.allocationSize(value.txid) +
        FfiConverterUInt32.allocationSize(value.vout) +
        0;
  }
}

class Output {
  final Script? redeemScript;
  final Script? witnessScript;
  final Map<String, KeySource> bip32Derivation;
  final String? tapInternalKey;
  final TapTree? tapTree;
  final Map<String, TapKeyOrigin> tapKeyOrigins;
  final Map<ProprietaryKey, Uint8List> proprietary;
  final Map<Key, Uint8List> unknown;
  Output(
    this.redeemScript,
    this.witnessScript,
    this.bip32Derivation,
    this.tapInternalKey,
    this.tapTree,
    this.tapKeyOrigins,
    this.proprietary,
    this.unknown,
  );
}

class FfiConverterOutput {
  static Output lift(RustBuffer buf) {
    return FfiConverterOutput.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Output> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final redeemScript_lifted = FfiConverterOptionalScript.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final redeemScript = redeemScript_lifted.value;
    new_offset += redeemScript_lifted.bytesRead;
    final witnessScript_lifted = FfiConverterOptionalScript.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final witnessScript = witnessScript_lifted.value;
    new_offset += witnessScript_lifted.bytesRead;
    final bip32Derivation_lifted = FfiConverterMapStringToKeySource.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final bip32Derivation = bip32Derivation_lifted.value;
    new_offset += bip32Derivation_lifted.bytesRead;
    final tapInternalKey_lifted = FfiConverterOptionalString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapInternalKey = tapInternalKey_lifted.value;
    new_offset += tapInternalKey_lifted.bytesRead;
    final tapTree_lifted = FfiConverterOptionalTapTree.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapTree = tapTree_lifted.value;
    new_offset += tapTree_lifted.bytesRead;
    final tapKeyOrigins_lifted = FfiConverterMapStringToTapKeyOrigin.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapKeyOrigins = tapKeyOrigins_lifted.value;
    new_offset += tapKeyOrigins_lifted.bytesRead;
    final proprietary_lifted = FfiConverterMapProprietaryKeyToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final proprietary = proprietary_lifted.value;
    new_offset += proprietary_lifted.bytesRead;
    final unknown_lifted = FfiConverterMapKeyToUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final unknown = unknown_lifted.value;
    new_offset += unknown_lifted.bytesRead;
    return LiftRetVal(
      Output(
        redeemScript,
        witnessScript,
        bip32Derivation,
        tapInternalKey,
        tapTree,
        tapKeyOrigins,
        proprietary,
        unknown,
      ),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(Output value) {
    final total_length =
        FfiConverterOptionalScript.allocationSize(value.redeemScript) +
        FfiConverterOptionalScript.allocationSize(value.witnessScript) +
        FfiConverterMapStringToKeySource.allocationSize(value.bip32Derivation) +
        FfiConverterOptionalString.allocationSize(value.tapInternalKey) +
        FfiConverterOptionalTapTree.allocationSize(value.tapTree) +
        FfiConverterMapStringToTapKeyOrigin.allocationSize(
          value.tapKeyOrigins,
        ) +
        FfiConverterMapProprietaryKeyToUint8List.allocationSize(
          value.proprietary,
        ) +
        FfiConverterMapKeyToUint8List.allocationSize(value.unknown) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Output value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalScript.write(
      value.redeemScript,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalScript.write(
      value.witnessScript,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToKeySource.write(
      value.bip32Derivation,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalString.write(
      value.tapInternalKey,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalTapTree.write(
      value.tapTree,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapStringToTapKeyOrigin.write(
      value.tapKeyOrigins,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapProprietaryKeyToUint8List.write(
      value.proprietary,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapKeyToUint8List.write(
      value.unknown,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Output value) {
    return FfiConverterOptionalScript.allocationSize(value.redeemScript) +
        FfiConverterOptionalScript.allocationSize(value.witnessScript) +
        FfiConverterMapStringToKeySource.allocationSize(value.bip32Derivation) +
        FfiConverterOptionalString.allocationSize(value.tapInternalKey) +
        FfiConverterOptionalTapTree.allocationSize(value.tapTree) +
        FfiConverterMapStringToTapKeyOrigin.allocationSize(
          value.tapKeyOrigins,
        ) +
        FfiConverterMapProprietaryKeyToUint8List.allocationSize(
          value.proprietary,
        ) +
        FfiConverterMapKeyToUint8List.allocationSize(value.unknown) +
        0;
  }
}

class Peer {
  final IpAddress address;
  final int? port;
  final bool v2Transport;
  Peer(this.address, this.port, this.v2Transport);
}

class FfiConverterPeer {
  static Peer lift(RustBuffer buf) {
    return FfiConverterPeer.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Peer> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final address_lifted = IpAddress.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final address = address_lifted.value;
    new_offset += address_lifted.bytesRead;
    final port_lifted = FfiConverterOptionalUInt16.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final port = port_lifted.value;
    new_offset += port_lifted.bytesRead;
    final v2Transport_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final v2Transport = v2Transport_lifted.value;
    new_offset += v2Transport_lifted.bytesRead;
    return LiftRetVal(
      Peer(address, port, v2Transport),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(Peer value) {
    final total_length =
        IpAddress.allocationSize(value.address) +
        FfiConverterOptionalUInt16.allocationSize(value.port) +
        FfiConverterBool.allocationSize(value.v2Transport) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Peer value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += IpAddress.write(
      value.address,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalUInt16.write(
      value.port,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterBool.write(
      value.v2Transport,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Peer value) {
    return IpAddress.allocationSize(value.address) +
        FfiConverterOptionalUInt16.allocationSize(value.port) +
        FfiConverterBool.allocationSize(value.v2Transport) +
        0;
  }
}

class ProprietaryKey {
  final Uint8List prefix;
  final int subtype;
  final Uint8List key;
  ProprietaryKey(this.prefix, this.subtype, this.key);
}

class FfiConverterProprietaryKey {
  static ProprietaryKey lift(RustBuffer buf) {
    return FfiConverterProprietaryKey.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ProprietaryKey> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final prefix_lifted = FfiConverterUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final prefix = prefix_lifted.value;
    new_offset += prefix_lifted.bytesRead;
    final subtype_lifted = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final subtype = subtype_lifted.value;
    new_offset += subtype_lifted.bytesRead;
    final key_lifted = FfiConverterUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final key = key_lifted.value;
    new_offset += key_lifted.bytesRead;
    return LiftRetVal(
      ProprietaryKey(prefix, subtype, key),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(ProprietaryKey value) {
    final total_length =
        FfiConverterUint8List.allocationSize(value.prefix) +
        FfiConverterUInt8.allocationSize(value.subtype) +
        FfiConverterUint8List.allocationSize(value.key) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ProprietaryKey value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUint8List.write(
      value.prefix,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt8.write(
      value.subtype,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUint8List.write(
      value.key,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ProprietaryKey value) {
    return FfiConverterUint8List.allocationSize(value.prefix) +
        FfiConverterUInt8.allocationSize(value.subtype) +
        FfiConverterUint8List.allocationSize(value.key) +
        0;
  }
}

class ScriptAmount {
  final Script script;
  final Amount amount;
  ScriptAmount(this.script, this.amount);
}

class FfiConverterScriptAmount {
  static ScriptAmount lift(RustBuffer buf) {
    return FfiConverterScriptAmount.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ScriptAmount> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final script_lifted = Script.read(Uint8List.view(buf.buffer, new_offset));
    final script = script_lifted.value;
    new_offset += script_lifted.bytesRead;
    final amount_lifted = Amount.read(Uint8List.view(buf.buffer, new_offset));
    final amount = amount_lifted.value;
    new_offset += amount_lifted.bytesRead;
    return LiftRetVal(
      ScriptAmount(script, amount),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(ScriptAmount value) {
    final total_length =
        Script.allocationSize(value.script) +
        Amount.allocationSize(value.amount) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ScriptAmount value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Script.write(
      value.script,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.amount,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ScriptAmount value) {
    return Script.allocationSize(value.script) +
        Amount.allocationSize(value.amount) +
        0;
  }
}

class SentAndReceivedValues {
  final Amount sent;
  final Amount received;
  SentAndReceivedValues(this.sent, this.received);
}

class FfiConverterSentAndReceivedValues {
  static SentAndReceivedValues lift(RustBuffer buf) {
    return FfiConverterSentAndReceivedValues.read(buf.asUint8List()).value;
  }

  static LiftRetVal<SentAndReceivedValues> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sent_lifted = Amount.read(Uint8List.view(buf.buffer, new_offset));
    final sent = sent_lifted.value;
    new_offset += sent_lifted.bytesRead;
    final received_lifted = Amount.read(Uint8List.view(buf.buffer, new_offset));
    final received = received_lifted.value;
    new_offset += received_lifted.bytesRead;
    return LiftRetVal(
      SentAndReceivedValues(sent, received),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(SentAndReceivedValues value) {
    final total_length =
        Amount.allocationSize(value.sent) +
        Amount.allocationSize(value.received) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(SentAndReceivedValues value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Amount.write(
      value.sent,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.received,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(SentAndReceivedValues value) {
    return Amount.allocationSize(value.sent) +
        Amount.allocationSize(value.received) +
        0;
  }
}

class ServerFeaturesRes {
  final String serverVersion;
  final BlockHash genesisHash;
  final String protocolMin;
  final String protocolMax;
  final String? hashFunction;
  final int? pruning;
  ServerFeaturesRes(
    this.serverVersion,
    this.genesisHash,
    this.protocolMin,
    this.protocolMax,
    this.hashFunction,
    this.pruning,
  );
}

class FfiConverterServerFeaturesRes {
  static ServerFeaturesRes lift(RustBuffer buf) {
    return FfiConverterServerFeaturesRes.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ServerFeaturesRes> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final serverVersion_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final serverVersion = serverVersion_lifted.value;
    new_offset += serverVersion_lifted.bytesRead;
    final genesisHash_lifted = BlockHash.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final genesisHash = genesisHash_lifted.value;
    new_offset += genesisHash_lifted.bytesRead;
    final protocolMin_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final protocolMin = protocolMin_lifted.value;
    new_offset += protocolMin_lifted.bytesRead;
    final protocolMax_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final protocolMax = protocolMax_lifted.value;
    new_offset += protocolMax_lifted.bytesRead;
    final hashFunction_lifted = FfiConverterOptionalString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hashFunction = hashFunction_lifted.value;
    new_offset += hashFunction_lifted.bytesRead;
    final pruning_lifted = FfiConverterOptionalInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final pruning = pruning_lifted.value;
    new_offset += pruning_lifted.bytesRead;
    return LiftRetVal(
      ServerFeaturesRes(
        serverVersion,
        genesisHash,
        protocolMin,
        protocolMax,
        hashFunction,
        pruning,
      ),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(ServerFeaturesRes value) {
    final total_length =
        FfiConverterString.allocationSize(value.serverVersion) +
        BlockHash.allocationSize(value.genesisHash) +
        FfiConverterString.allocationSize(value.protocolMin) +
        FfiConverterString.allocationSize(value.protocolMax) +
        FfiConverterOptionalString.allocationSize(value.hashFunction) +
        FfiConverterOptionalInt64.allocationSize(value.pruning) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ServerFeaturesRes value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
      value.serverVersion,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += BlockHash.write(
      value.genesisHash,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterString.write(
      value.protocolMin,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterString.write(
      value.protocolMax,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalString.write(
      value.hashFunction,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalInt64.write(
      value.pruning,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ServerFeaturesRes value) {
    return FfiConverterString.allocationSize(value.serverVersion) +
        BlockHash.allocationSize(value.genesisHash) +
        FfiConverterString.allocationSize(value.protocolMin) +
        FfiConverterString.allocationSize(value.protocolMax) +
        FfiConverterOptionalString.allocationSize(value.hashFunction) +
        FfiConverterOptionalInt64.allocationSize(value.pruning) +
        0;
  }
}

class SignOptions {
  final bool trustWitnessUtxo;
  final int? assumeHeight;
  final bool allowAllSighashes;
  final bool tryFinalize;
  final bool signWithTapInternalKey;
  final bool allowGrinding;
  SignOptions(
    this.trustWitnessUtxo,
    this.assumeHeight,
    this.allowAllSighashes,
    this.tryFinalize,
    this.signWithTapInternalKey,
    this.allowGrinding,
  );
}

class FfiConverterSignOptions {
  static SignOptions lift(RustBuffer buf) {
    return FfiConverterSignOptions.read(buf.asUint8List()).value;
  }

  static LiftRetVal<SignOptions> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final trustWitnessUtxo_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final trustWitnessUtxo = trustWitnessUtxo_lifted.value;
    new_offset += trustWitnessUtxo_lifted.bytesRead;
    final assumeHeight_lifted = FfiConverterOptionalUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final assumeHeight = assumeHeight_lifted.value;
    new_offset += assumeHeight_lifted.bytesRead;
    final allowAllSighashes_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final allowAllSighashes = allowAllSighashes_lifted.value;
    new_offset += allowAllSighashes_lifted.bytesRead;
    final tryFinalize_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tryFinalize = tryFinalize_lifted.value;
    new_offset += tryFinalize_lifted.bytesRead;
    final signWithTapInternalKey_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final signWithTapInternalKey = signWithTapInternalKey_lifted.value;
    new_offset += signWithTapInternalKey_lifted.bytesRead;
    final allowGrinding_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final allowGrinding = allowGrinding_lifted.value;
    new_offset += allowGrinding_lifted.bytesRead;
    return LiftRetVal(
      SignOptions(
        trustWitnessUtxo,
        assumeHeight,
        allowAllSighashes,
        tryFinalize,
        signWithTapInternalKey,
        allowGrinding,
      ),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(SignOptions value) {
    final total_length =
        FfiConverterBool.allocationSize(value.trustWitnessUtxo) +
        FfiConverterOptionalUInt32.allocationSize(value.assumeHeight) +
        FfiConverterBool.allocationSize(value.allowAllSighashes) +
        FfiConverterBool.allocationSize(value.tryFinalize) +
        FfiConverterBool.allocationSize(value.signWithTapInternalKey) +
        FfiConverterBool.allocationSize(value.allowGrinding) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(SignOptions value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterBool.write(
      value.trustWitnessUtxo,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalUInt32.write(
      value.assumeHeight,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterBool.write(
      value.allowAllSighashes,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterBool.write(
      value.tryFinalize,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterBool.write(
      value.signWithTapInternalKey,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterBool.write(
      value.allowGrinding,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(SignOptions value) {
    return FfiConverterBool.allocationSize(value.trustWitnessUtxo) +
        FfiConverterOptionalUInt32.allocationSize(value.assumeHeight) +
        FfiConverterBool.allocationSize(value.allowAllSighashes) +
        FfiConverterBool.allocationSize(value.tryFinalize) +
        FfiConverterBool.allocationSize(value.signWithTapInternalKey) +
        FfiConverterBool.allocationSize(value.allowGrinding) +
        0;
  }
}

class Socks5Proxy {
  final IpAddress address;
  final int port;
  Socks5Proxy(this.address, this.port);
}

class FfiConverterSocks5Proxy {
  static Socks5Proxy lift(RustBuffer buf) {
    return FfiConverterSocks5Proxy.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Socks5Proxy> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final address_lifted = IpAddress.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final address = address_lifted.value;
    new_offset += address_lifted.bytesRead;
    final port_lifted = FfiConverterUInt16.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final port = port_lifted.value;
    new_offset += port_lifted.bytesRead;
    return LiftRetVal(
      Socks5Proxy(address, port),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(Socks5Proxy value) {
    final total_length =
        IpAddress.allocationSize(value.address) +
        FfiConverterUInt16.allocationSize(value.port) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Socks5Proxy value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += IpAddress.write(
      value.address,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt16.write(
      value.port,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Socks5Proxy value) {
    return IpAddress.allocationSize(value.address) +
        FfiConverterUInt16.allocationSize(value.port) +
        0;
  }
}

class TapKeyOrigin {
  final List<String> tapLeafHashes;
  final KeySource keySource;
  TapKeyOrigin(this.tapLeafHashes, this.keySource);
}

class FfiConverterTapKeyOrigin {
  static TapKeyOrigin lift(RustBuffer buf) {
    return FfiConverterTapKeyOrigin.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TapKeyOrigin> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final tapLeafHashes_lifted = FfiConverterSequenceString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapLeafHashes = tapLeafHashes_lifted.value;
    new_offset += tapLeafHashes_lifted.bytesRead;
    final keySource_lifted = FfiConverterKeySource.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final keySource = keySource_lifted.value;
    new_offset += keySource_lifted.bytesRead;
    return LiftRetVal(
      TapKeyOrigin(tapLeafHashes, keySource),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(TapKeyOrigin value) {
    final total_length =
        FfiConverterSequenceString.allocationSize(value.tapLeafHashes) +
        FfiConverterKeySource.allocationSize(value.keySource) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TapKeyOrigin value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceString.write(
      value.tapLeafHashes,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterKeySource.write(
      value.keySource,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TapKeyOrigin value) {
    return FfiConverterSequenceString.allocationSize(value.tapLeafHashes) +
        FfiConverterKeySource.allocationSize(value.keySource) +
        0;
  }
}

class TapScriptEntry {
  final Script script;
  final int leafVersion;
  TapScriptEntry(this.script, this.leafVersion);
}

class FfiConverterTapScriptEntry {
  static TapScriptEntry lift(RustBuffer buf) {
    return FfiConverterTapScriptEntry.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TapScriptEntry> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final script_lifted = Script.read(Uint8List.view(buf.buffer, new_offset));
    final script = script_lifted.value;
    new_offset += script_lifted.bytesRead;
    final leafVersion_lifted = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final leafVersion = leafVersion_lifted.value;
    new_offset += leafVersion_lifted.bytesRead;
    return LiftRetVal(
      TapScriptEntry(script, leafVersion),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(TapScriptEntry value) {
    final total_length =
        Script.allocationSize(value.script) +
        FfiConverterUInt8.allocationSize(value.leafVersion) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TapScriptEntry value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Script.write(
      value.script,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt8.write(
      value.leafVersion,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TapScriptEntry value) {
    return Script.allocationSize(value.script) +
        FfiConverterUInt8.allocationSize(value.leafVersion) +
        0;
  }
}

class TapScriptSigKey {
  final String xonlyPubkey;
  final String tapLeafHash;
  TapScriptSigKey(this.xonlyPubkey, this.tapLeafHash);
}

class FfiConverterTapScriptSigKey {
  static TapScriptSigKey lift(RustBuffer buf) {
    return FfiConverterTapScriptSigKey.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TapScriptSigKey> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final xonlyPubkey_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final xonlyPubkey = xonlyPubkey_lifted.value;
    new_offset += xonlyPubkey_lifted.bytesRead;
    final tapLeafHash_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final tapLeafHash = tapLeafHash_lifted.value;
    new_offset += tapLeafHash_lifted.bytesRead;
    return LiftRetVal(
      TapScriptSigKey(xonlyPubkey, tapLeafHash),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(TapScriptSigKey value) {
    final total_length =
        FfiConverterString.allocationSize(value.xonlyPubkey) +
        FfiConverterString.allocationSize(value.tapLeafHash) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TapScriptSigKey value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
      value.xonlyPubkey,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterString.write(
      value.tapLeafHash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TapScriptSigKey value) {
    return FfiConverterString.allocationSize(value.xonlyPubkey) +
        FfiConverterString.allocationSize(value.tapLeafHash) +
        0;
  }
}

class Tx {
  final Txid txid;
  final int version;
  final int locktime;
  final int size;
  final int weight;
  final int fee;
  final TxStatus status;
  Tx(
    this.txid,
    this.version,
    this.locktime,
    this.size,
    this.weight,
    this.fee,
    this.status,
  );
}

class FfiConverterTx {
  static Tx lift(RustBuffer buf) {
    return FfiConverterTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Tx> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    final version_lifted = FfiConverterInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final version = version_lifted.value;
    new_offset += version_lifted.bytesRead;
    final locktime_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final locktime = locktime_lifted.value;
    new_offset += locktime_lifted.bytesRead;
    final size_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final size = size_lifted.value;
    new_offset += size_lifted.bytesRead;
    final weight_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final weight = weight_lifted.value;
    new_offset += weight_lifted.bytesRead;
    final fee_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final fee = fee_lifted.value;
    new_offset += fee_lifted.bytesRead;
    final status_lifted = FfiConverterTxStatus.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final status = status_lifted.value;
    new_offset += status_lifted.bytesRead;
    return LiftRetVal(
      Tx(txid, version, locktime, size, weight, fee, status),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(Tx value) {
    final total_length =
        Txid.allocationSize(value.txid) +
        FfiConverterInt32.allocationSize(value.version) +
        FfiConverterUInt32.allocationSize(value.locktime) +
        FfiConverterUInt64.allocationSize(value.size) +
        FfiConverterUInt64.allocationSize(value.weight) +
        FfiConverterUInt64.allocationSize(value.fee) +
        FfiConverterTxStatus.allocationSize(value.status) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(Tx value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Txid.write(
      value.txid,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterInt32.write(
      value.version,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      value.locktime,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      value.size,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      value.weight,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      value.fee,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterTxStatus.write(
      value.status,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(Tx value) {
    return Txid.allocationSize(value.txid) +
        FfiConverterInt32.allocationSize(value.version) +
        FfiConverterUInt32.allocationSize(value.locktime) +
        FfiConverterUInt64.allocationSize(value.size) +
        FfiConverterUInt64.allocationSize(value.weight) +
        FfiConverterUInt64.allocationSize(value.fee) +
        FfiConverterTxStatus.allocationSize(value.status) +
        0;
  }
}

class TxDetails {
  final Txid txid;
  final Amount sent;
  final Amount received;
  final Amount? fee;
  final double? feeRate;
  final int balanceDelta;
  final ChainPosition chainPosition;
  final Transaction tx;
  TxDetails(
    this.txid,
    this.sent,
    this.received,
    this.fee,
    this.feeRate,
    this.balanceDelta,
    this.chainPosition,
    this.tx,
  );
}

class FfiConverterTxDetails {
  static TxDetails lift(RustBuffer buf) {
    return FfiConverterTxDetails.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TxDetails> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    final sent_lifted = Amount.read(Uint8List.view(buf.buffer, new_offset));
    final sent = sent_lifted.value;
    new_offset += sent_lifted.bytesRead;
    final received_lifted = Amount.read(Uint8List.view(buf.buffer, new_offset));
    final received = received_lifted.value;
    new_offset += received_lifted.bytesRead;
    final fee_lifted = FfiConverterOptionalAmount.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final fee = fee_lifted.value;
    new_offset += fee_lifted.bytesRead;
    final feeRate_lifted = FfiConverterOptionalDouble32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final feeRate = feeRate_lifted.value;
    new_offset += feeRate_lifted.bytesRead;
    final balanceDelta_lifted = FfiConverterInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final balanceDelta = balanceDelta_lifted.value;
    new_offset += balanceDelta_lifted.bytesRead;
    final chainPosition_lifted = FfiConverterChainPosition.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final chainPosition = chainPosition_lifted.value;
    new_offset += chainPosition_lifted.bytesRead;
    final tx_lifted = Transaction.read(Uint8List.view(buf.buffer, new_offset));
    final tx = tx_lifted.value;
    new_offset += tx_lifted.bytesRead;
    return LiftRetVal(
      TxDetails(
        txid,
        sent,
        received,
        fee,
        feeRate,
        balanceDelta,
        chainPosition,
        tx,
      ),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(TxDetails value) {
    final total_length =
        Txid.allocationSize(value.txid) +
        Amount.allocationSize(value.sent) +
        Amount.allocationSize(value.received) +
        FfiConverterOptionalAmount.allocationSize(value.fee) +
        FfiConverterOptionalDouble32.allocationSize(value.feeRate) +
        FfiConverterInt64.allocationSize(value.balanceDelta) +
        FfiConverterChainPosition.allocationSize(value.chainPosition) +
        Transaction.allocationSize(value.tx) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TxDetails value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Txid.write(
      value.txid,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.sent,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Amount.write(
      value.received,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalAmount.write(
      value.fee,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalDouble32.write(
      value.feeRate,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterInt64.write(
      value.balanceDelta,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterChainPosition.write(
      value.chainPosition,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Transaction.write(
      value.tx,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TxDetails value) {
    return Txid.allocationSize(value.txid) +
        Amount.allocationSize(value.sent) +
        Amount.allocationSize(value.received) +
        FfiConverterOptionalAmount.allocationSize(value.fee) +
        FfiConverterOptionalDouble32.allocationSize(value.feeRate) +
        FfiConverterInt64.allocationSize(value.balanceDelta) +
        FfiConverterChainPosition.allocationSize(value.chainPosition) +
        Transaction.allocationSize(value.tx) +
        0;
  }
}

class TxGraphChangeSet {
  final List<Transaction> txs;
  final Map<HashableOutPoint, TxOut> txouts;
  final List<Anchor> anchors;
  final Map<Txid, int> lastSeen;
  final Map<Txid, int> firstSeen;
  final Map<Txid, int> lastEvicted;
  TxGraphChangeSet(
    this.txs,
    this.txouts,
    this.anchors,
    this.lastSeen,
    this.firstSeen,
    this.lastEvicted,
  );
}

class FfiConverterTxGraphChangeSet {
  static TxGraphChangeSet lift(RustBuffer buf) {
    return FfiConverterTxGraphChangeSet.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TxGraphChangeSet> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txs_lifted = FfiConverterSequenceTransaction.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final txs = txs_lifted.value;
    new_offset += txs_lifted.bytesRead;
    final txouts_lifted = FfiConverterMapHashableOutPointToTxOut.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final txouts = txouts_lifted.value;
    new_offset += txouts_lifted.bytesRead;
    final anchors_lifted = FfiConverterSequenceAnchor.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final anchors = anchors_lifted.value;
    new_offset += anchors_lifted.bytesRead;
    final lastSeen_lifted = FfiConverterMapTxidToUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final lastSeen = lastSeen_lifted.value;
    new_offset += lastSeen_lifted.bytesRead;
    final firstSeen_lifted = FfiConverterMapTxidToUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final firstSeen = firstSeen_lifted.value;
    new_offset += firstSeen_lifted.bytesRead;
    final lastEvicted_lifted = FfiConverterMapTxidToUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final lastEvicted = lastEvicted_lifted.value;
    new_offset += lastEvicted_lifted.bytesRead;
    return LiftRetVal(
      TxGraphChangeSet(txs, txouts, anchors, lastSeen, firstSeen, lastEvicted),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(TxGraphChangeSet value) {
    final total_length =
        FfiConverterSequenceTransaction.allocationSize(value.txs) +
        FfiConverterMapHashableOutPointToTxOut.allocationSize(value.txouts) +
        FfiConverterSequenceAnchor.allocationSize(value.anchors) +
        FfiConverterMapTxidToUInt64.allocationSize(value.lastSeen) +
        FfiConverterMapTxidToUInt64.allocationSize(value.firstSeen) +
        FfiConverterMapTxidToUInt64.allocationSize(value.lastEvicted) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TxGraphChangeSet value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceTransaction.write(
      value.txs,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapHashableOutPointToTxOut.write(
      value.txouts,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterSequenceAnchor.write(
      value.anchors,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapTxidToUInt64.write(
      value.lastSeen,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapTxidToUInt64.write(
      value.firstSeen,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapTxidToUInt64.write(
      value.lastEvicted,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TxGraphChangeSet value) {
    return FfiConverterSequenceTransaction.allocationSize(value.txs) +
        FfiConverterMapHashableOutPointToTxOut.allocationSize(value.txouts) +
        FfiConverterSequenceAnchor.allocationSize(value.anchors) +
        FfiConverterMapTxidToUInt64.allocationSize(value.lastSeen) +
        FfiConverterMapTxidToUInt64.allocationSize(value.firstSeen) +
        FfiConverterMapTxidToUInt64.allocationSize(value.lastEvicted) +
        0;
  }
}

class TxIn {
  final OutPoint previousOutput;
  final Script scriptSig;
  final int sequence;
  final List<Uint8List> witness;
  TxIn(this.previousOutput, this.scriptSig, this.sequence, this.witness);
}

class FfiConverterTxIn {
  static TxIn lift(RustBuffer buf) {
    return FfiConverterTxIn.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TxIn> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final previousOutput_lifted = FfiConverterOutPoint.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final previousOutput = previousOutput_lifted.value;
    new_offset += previousOutput_lifted.bytesRead;
    final scriptSig_lifted = Script.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final scriptSig = scriptSig_lifted.value;
    new_offset += scriptSig_lifted.bytesRead;
    final sequence_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final sequence = sequence_lifted.value;
    new_offset += sequence_lifted.bytesRead;
    final witness_lifted = FfiConverterSequenceUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final witness = witness_lifted.value;
    new_offset += witness_lifted.bytesRead;
    return LiftRetVal(
      TxIn(previousOutput, scriptSig, sequence, witness),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(TxIn value) {
    final total_length =
        FfiConverterOutPoint.allocationSize(value.previousOutput) +
        Script.allocationSize(value.scriptSig) +
        FfiConverterUInt32.allocationSize(value.sequence) +
        FfiConverterSequenceUint8List.allocationSize(value.witness) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TxIn value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOutPoint.write(
      value.previousOutput,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Script.write(
      value.scriptSig,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      value.sequence,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterSequenceUint8List.write(
      value.witness,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TxIn value) {
    return FfiConverterOutPoint.allocationSize(value.previousOutput) +
        Script.allocationSize(value.scriptSig) +
        FfiConverterUInt32.allocationSize(value.sequence) +
        FfiConverterSequenceUint8List.allocationSize(value.witness) +
        0;
  }
}

class TxOut {
  final Amount value;
  final Script scriptPubkey;
  TxOut(this.value, this.scriptPubkey);
}

class FfiConverterTxOut {
  static TxOut lift(RustBuffer buf) {
    return FfiConverterTxOut.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TxOut> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final value_lifted = Amount.read(Uint8List.view(buf.buffer, new_offset));
    final value = value_lifted.value;
    new_offset += value_lifted.bytesRead;
    final scriptPubkey_lifted = Script.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final scriptPubkey = scriptPubkey_lifted.value;
    new_offset += scriptPubkey_lifted.bytesRead;
    return LiftRetVal(
      TxOut(value, scriptPubkey),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(TxOut value) {
    final total_length =
        Amount.allocationSize(value.value) +
        Script.allocationSize(value.scriptPubkey) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TxOut value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Amount.write(
      value.value,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += Script.write(
      value.scriptPubkey,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TxOut value) {
    return Amount.allocationSize(value.value) +
        Script.allocationSize(value.scriptPubkey) +
        0;
  }
}

class TxStatus {
  final bool confirmed;
  final int? blockHeight;
  final BlockHash? blockHash;
  final int? blockTime;
  TxStatus(this.confirmed, this.blockHeight, this.blockHash, this.blockTime);
}

class FfiConverterTxStatus {
  static TxStatus lift(RustBuffer buf) {
    return FfiConverterTxStatus.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TxStatus> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final confirmed_lifted = FfiConverterBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final confirmed = confirmed_lifted.value;
    new_offset += confirmed_lifted.bytesRead;
    final blockHeight_lifted = FfiConverterOptionalUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final blockHeight = blockHeight_lifted.value;
    new_offset += blockHeight_lifted.bytesRead;
    final blockHash_lifted = FfiConverterOptionalBlockHash.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final blockHash = blockHash_lifted.value;
    new_offset += blockHash_lifted.bytesRead;
    final blockTime_lifted = FfiConverterOptionalUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final blockTime = blockTime_lifted.value;
    new_offset += blockTime_lifted.bytesRead;
    return LiftRetVal(
      TxStatus(confirmed, blockHeight, blockHash, blockTime),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(TxStatus value) {
    final total_length =
        FfiConverterBool.allocationSize(value.confirmed) +
        FfiConverterOptionalUInt32.allocationSize(value.blockHeight) +
        FfiConverterOptionalBlockHash.allocationSize(value.blockHash) +
        FfiConverterOptionalUInt64.allocationSize(value.blockTime) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TxStatus value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterBool.write(
      value.confirmed,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalUInt32.write(
      value.blockHeight,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalBlockHash.write(
      value.blockHash,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalUInt64.write(
      value.blockTime,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TxStatus value) {
    return FfiConverterBool.allocationSize(value.confirmed) +
        FfiConverterOptionalUInt32.allocationSize(value.blockHeight) +
        FfiConverterOptionalBlockHash.allocationSize(value.blockHash) +
        FfiConverterOptionalUInt64.allocationSize(value.blockTime) +
        0;
  }
}

class UnconfirmedTx {
  final Transaction tx;
  final int lastSeen;
  UnconfirmedTx(this.tx, this.lastSeen);
}

class FfiConverterUnconfirmedTx {
  static UnconfirmedTx lift(RustBuffer buf) {
    return FfiConverterUnconfirmedTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<UnconfirmedTx> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final tx_lifted = Transaction.read(Uint8List.view(buf.buffer, new_offset));
    final tx = tx_lifted.value;
    new_offset += tx_lifted.bytesRead;
    final lastSeen_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final lastSeen = lastSeen_lifted.value;
    new_offset += lastSeen_lifted.bytesRead;
    return LiftRetVal(
      UnconfirmedTx(tx, lastSeen),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(UnconfirmedTx value) {
    final total_length =
        Transaction.allocationSize(value.tx) +
        FfiConverterUInt64.allocationSize(value.lastSeen) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(UnconfirmedTx value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += Transaction.write(
      value.tx,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      value.lastSeen,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(UnconfirmedTx value) {
    return Transaction.allocationSize(value.tx) +
        FfiConverterUInt64.allocationSize(value.lastSeen) +
        0;
  }
}

class WitnessProgram {
  final int version;
  final Uint8List program;
  WitnessProgram(this.version, this.program);
}

class FfiConverterWitnessProgram {
  static WitnessProgram lift(RustBuffer buf) {
    return FfiConverterWitnessProgram.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WitnessProgram> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final version_lifted = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final version = version_lifted.value;
    new_offset += version_lifted.bytesRead;
    final program_lifted = FfiConverterUint8List.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final program = program_lifted.value;
    new_offset += program_lifted.bytesRead;
    return LiftRetVal(
      WitnessProgram(version, program),
      new_offset - buf.offsetInBytes,
    );
  }

  static RustBuffer lower(WitnessProgram value) {
    final total_length =
        FfiConverterUInt8.allocationSize(value.version) +
        FfiConverterUint8List.allocationSize(value.program) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WitnessProgram value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterUInt8.write(
      value.version,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUint8List.write(
      value.program,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WitnessProgram value) {
    return FfiConverterUInt8.allocationSize(value.version) +
        FfiConverterUint8List.allocationSize(value.program) +
        0;
  }
}

abstract class AddressData {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterAddressData {
  static AddressData lift(RustBuffer buffer) {
    return FfiConverterAddressData.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<AddressData> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return P2pkhAddressData.read(subview);
      case 2:
        return P2shAddressData.read(subview);
      case 3:
        return SegwitAddressData.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(AddressData value) {
    return value.lower();
  }

  static int allocationSize(AddressData value) {
    return value.allocationSize();
  }

  static int write(AddressData value, Uint8List buf) {
    return value.write(buf);
  }
}

class P2pkhAddressData extends AddressData {
  final String pubkeyHash;
  P2pkhAddressData(String this.pubkeyHash);
  P2pkhAddressData._(String this.pubkeyHash);
  static LiftRetVal<P2pkhAddressData> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final pubkeyHash_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final pubkeyHash = pubkeyHash_lifted.value;
    new_offset += pubkeyHash_lifted.bytesRead;
    return LiftRetVal(P2pkhAddressData._(pubkeyHash), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(pubkeyHash) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      pubkeyHash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class P2shAddressData extends AddressData {
  final String scriptHash;
  P2shAddressData(String this.scriptHash);
  P2shAddressData._(String this.scriptHash);
  static LiftRetVal<P2shAddressData> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final scriptHash_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final scriptHash = scriptHash_lifted.value;
    new_offset += scriptHash_lifted.bytesRead;
    return LiftRetVal(P2shAddressData._(scriptHash), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(scriptHash) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      scriptHash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class SegwitAddressData extends AddressData {
  final WitnessProgram witnessProgram;
  SegwitAddressData(WitnessProgram this.witnessProgram);
  SegwitAddressData._(WitnessProgram this.witnessProgram);
  static LiftRetVal<SegwitAddressData> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final witnessProgram_lifted = FfiConverterWitnessProgram.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final witnessProgram = witnessProgram_lifted.value;
    new_offset += witnessProgram_lifted.bytesRead;
    return LiftRetVal(SegwitAddressData._(witnessProgram), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterWitnessProgram.allocationSize(witnessProgram) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterWitnessProgram.write(
      witnessProgram,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

abstract class AddressParseException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterAddressParseException {
  static AddressParseException lift(RustBuffer buffer) {
    return FfiConverterAddressParseException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<AddressParseException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return Base58AddressParseException.read(subview);
      case 2:
        return Bech32AddressParseException.read(subview);
      case 3:
        return WitnessVersionAddressParseException.read(subview);
      case 4:
        return WitnessProgramAddressParseException.read(subview);
      case 5:
        return UnknownHrpAddressParseException.read(subview);
      case 6:
        return LegacyAddressTooLongAddressParseException.read(subview);
      case 7:
        return InvalidBase58PayloadLengthAddressParseException.read(subview);
      case 8:
        return InvalidLegacyPrefixAddressParseException.read(subview);
      case 9:
        return NetworkValidationAddressParseException.read(subview);
      case 10:
        return OtherAddressParseErrAddressParseException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(AddressParseException value) {
    return value.lower();
  }

  static int allocationSize(AddressParseException value) {
    return value.allocationSize();
  }

  static int write(AddressParseException value, Uint8List buf) {
    return value.write(buf);
  }
}

class Base58AddressParseException extends AddressParseException {
  Base58AddressParseException();
  Base58AddressParseException._();
  static LiftRetVal<Base58AddressParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(Base58AddressParseException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "Base58AddressParseException";
  }
}

class Bech32AddressParseException extends AddressParseException {
  Bech32AddressParseException();
  Bech32AddressParseException._();
  static LiftRetVal<Bech32AddressParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(Bech32AddressParseException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "Bech32AddressParseException";
  }
}

class WitnessVersionAddressParseException extends AddressParseException {
  final String errorMessage;
  WitnessVersionAddressParseException(String this.errorMessage);
  WitnessVersionAddressParseException._(String this.errorMessage);
  static LiftRetVal<WitnessVersionAddressParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      WitnessVersionAddressParseException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "WitnessVersionAddressParseException($errorMessage)";
  }
}

class WitnessProgramAddressParseException extends AddressParseException {
  final String errorMessage;
  WitnessProgramAddressParseException(String this.errorMessage);
  WitnessProgramAddressParseException._(String this.errorMessage);
  static LiftRetVal<WitnessProgramAddressParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      WitnessProgramAddressParseException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "WitnessProgramAddressParseException($errorMessage)";
  }
}

class UnknownHrpAddressParseException extends AddressParseException {
  UnknownHrpAddressParseException();
  UnknownHrpAddressParseException._();
  static LiftRetVal<UnknownHrpAddressParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(UnknownHrpAddressParseException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "UnknownHrpAddressParseException";
  }
}

class LegacyAddressTooLongAddressParseException extends AddressParseException {
  LegacyAddressTooLongAddressParseException();
  LegacyAddressTooLongAddressParseException._();
  static LiftRetVal<LegacyAddressTooLongAddressParseException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      LegacyAddressTooLongAddressParseException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "LegacyAddressTooLongAddressParseException";
  }
}

class InvalidBase58PayloadLengthAddressParseException
    extends AddressParseException {
  InvalidBase58PayloadLengthAddressParseException();
  InvalidBase58PayloadLengthAddressParseException._();
  static LiftRetVal<InvalidBase58PayloadLengthAddressParseException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      InvalidBase58PayloadLengthAddressParseException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidBase58PayloadLengthAddressParseException";
  }
}

class InvalidLegacyPrefixAddressParseException extends AddressParseException {
  InvalidLegacyPrefixAddressParseException();
  InvalidLegacyPrefixAddressParseException._();
  static LiftRetVal<InvalidLegacyPrefixAddressParseException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidLegacyPrefixAddressParseException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidLegacyPrefixAddressParseException";
  }
}

class NetworkValidationAddressParseException extends AddressParseException {
  NetworkValidationAddressParseException();
  NetworkValidationAddressParseException._();
  static LiftRetVal<NetworkValidationAddressParseException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NetworkValidationAddressParseException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NetworkValidationAddressParseException";
  }
}

class OtherAddressParseErrAddressParseException extends AddressParseException {
  OtherAddressParseErrAddressParseException();
  OtherAddressParseErrAddressParseException._();
  static LiftRetVal<OtherAddressParseErrAddressParseException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      OtherAddressParseErrAddressParseException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "OtherAddressParseErrAddressParseException";
  }
}

class AddressParseExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterAddressParseException.lift(errorBuf);
  }
}

final AddressParseExceptionErrorHandler addressParseExceptionErrorHandler =
    AddressParseExceptionErrorHandler();

abstract class Bip32Exception implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterBip32Exception {
  static Bip32Exception lift(RustBuffer buffer) {
    return FfiConverterBip32Exception.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<Bip32Exception> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return CannotDeriveFromHardenedKeyBip32Exception.read(subview);
      case 2:
        return Secp256k1Bip32Exception.read(subview);
      case 3:
        return InvalidChildNumberBip32Exception.read(subview);
      case 4:
        return InvalidChildNumberFormatBip32Exception.read(subview);
      case 5:
        return InvalidDerivationPathFormatBip32Exception.read(subview);
      case 6:
        return UnknownVersionBip32Exception.read(subview);
      case 7:
        return WrongExtendedKeyLengthBip32Exception.read(subview);
      case 8:
        return Base58Bip32Exception.read(subview);
      case 9:
        return HexBip32Exception.read(subview);
      case 10:
        return InvalidPublicKeyHexLengthBip32Exception.read(subview);
      case 11:
        return UnknownExceptionBip32Exception.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(Bip32Exception value) {
    return value.lower();
  }

  static int allocationSize(Bip32Exception value) {
    return value.allocationSize();
  }

  static int write(Bip32Exception value, Uint8List buf) {
    return value.write(buf);
  }
}

class CannotDeriveFromHardenedKeyBip32Exception extends Bip32Exception {
  CannotDeriveFromHardenedKeyBip32Exception();
  CannotDeriveFromHardenedKeyBip32Exception._();
  static LiftRetVal<CannotDeriveFromHardenedKeyBip32Exception> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      CannotDeriveFromHardenedKeyBip32Exception._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "CannotDeriveFromHardenedKeyBip32Exception";
  }
}

class Secp256k1Bip32Exception extends Bip32Exception {
  final String errorMessage;
  Secp256k1Bip32Exception(String this.errorMessage);
  Secp256k1Bip32Exception._(String this.errorMessage);
  static LiftRetVal<Secp256k1Bip32Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(Secp256k1Bip32Exception._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "Secp256k1Bip32Exception($errorMessage)";
  }
}

class InvalidChildNumberBip32Exception extends Bip32Exception {
  final int childNumber;
  InvalidChildNumberBip32Exception(int this.childNumber);
  InvalidChildNumberBip32Exception._(int this.childNumber);
  static LiftRetVal<InvalidChildNumberBip32Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final childNumber_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final childNumber = childNumber_lifted.value;
    new_offset += childNumber_lifted.bytesRead;
    return LiftRetVal(
      InvalidChildNumberBip32Exception._(childNumber),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(childNumber) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      childNumber,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidChildNumberBip32Exception($childNumber)";
  }
}

class InvalidChildNumberFormatBip32Exception extends Bip32Exception {
  InvalidChildNumberFormatBip32Exception();
  InvalidChildNumberFormatBip32Exception._();
  static LiftRetVal<InvalidChildNumberFormatBip32Exception> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidChildNumberFormatBip32Exception._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidChildNumberFormatBip32Exception";
  }
}

class InvalidDerivationPathFormatBip32Exception extends Bip32Exception {
  InvalidDerivationPathFormatBip32Exception();
  InvalidDerivationPathFormatBip32Exception._();
  static LiftRetVal<InvalidDerivationPathFormatBip32Exception> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      InvalidDerivationPathFormatBip32Exception._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidDerivationPathFormatBip32Exception";
  }
}

class UnknownVersionBip32Exception extends Bip32Exception {
  final String version;
  UnknownVersionBip32Exception(String this.version);
  UnknownVersionBip32Exception._(String this.version);
  static LiftRetVal<UnknownVersionBip32Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final version_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final version = version_lifted.value;
    new_offset += version_lifted.bytesRead;
    return LiftRetVal(UnknownVersionBip32Exception._(version), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(version) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      version,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "UnknownVersionBip32Exception($version)";
  }
}

class WrongExtendedKeyLengthBip32Exception extends Bip32Exception {
  final int length;
  WrongExtendedKeyLengthBip32Exception(int this.length);
  WrongExtendedKeyLengthBip32Exception._(int this.length);
  static LiftRetVal<WrongExtendedKeyLengthBip32Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final length_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final length = length_lifted.value;
    new_offset += length_lifted.bytesRead;
    return LiftRetVal(
      WrongExtendedKeyLengthBip32Exception._(length),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(length) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      length,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "WrongExtendedKeyLengthBip32Exception($length)";
  }
}

class Base58Bip32Exception extends Bip32Exception {
  final String errorMessage;
  Base58Bip32Exception(String this.errorMessage);
  Base58Bip32Exception._(String this.errorMessage);
  static LiftRetVal<Base58Bip32Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(Base58Bip32Exception._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "Base58Bip32Exception($errorMessage)";
  }
}

class HexBip32Exception extends Bip32Exception {
  final String errorMessage;
  HexBip32Exception(String this.errorMessage);
  HexBip32Exception._(String this.errorMessage);
  static LiftRetVal<HexBip32Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(HexBip32Exception._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "HexBip32Exception($errorMessage)";
  }
}

class InvalidPublicKeyHexLengthBip32Exception extends Bip32Exception {
  final int length;
  InvalidPublicKeyHexLengthBip32Exception(int this.length);
  InvalidPublicKeyHexLengthBip32Exception._(int this.length);
  static LiftRetVal<InvalidPublicKeyHexLengthBip32Exception> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final length_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final length = length_lifted.value;
    new_offset += length_lifted.bytesRead;
    return LiftRetVal(
      InvalidPublicKeyHexLengthBip32Exception._(length),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(length) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      length,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidPublicKeyHexLengthBip32Exception($length)";
  }
}

class UnknownExceptionBip32Exception extends Bip32Exception {
  final String errorMessage;
  UnknownExceptionBip32Exception(String this.errorMessage);
  UnknownExceptionBip32Exception._(String this.errorMessage);
  static LiftRetVal<UnknownExceptionBip32Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      UnknownExceptionBip32Exception._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 11);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "UnknownExceptionBip32Exception($errorMessage)";
  }
}

class Bip32ExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterBip32Exception.lift(errorBuf);
  }
}

final Bip32ExceptionErrorHandler bip32ExceptionErrorHandler =
    Bip32ExceptionErrorHandler();

abstract class Bip39Exception implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterBip39Exception {
  static Bip39Exception lift(RustBuffer buffer) {
    return FfiConverterBip39Exception.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<Bip39Exception> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return BadWordCountBip39Exception.read(subview);
      case 2:
        return UnknownWordBip39Exception.read(subview);
      case 3:
        return BadEntropyBitCountBip39Exception.read(subview);
      case 4:
        return InvalidChecksumBip39Exception.read(subview);
      case 5:
        return AmbiguousLanguagesBip39Exception.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(Bip39Exception value) {
    return value.lower();
  }

  static int allocationSize(Bip39Exception value) {
    return value.allocationSize();
  }

  static int write(Bip39Exception value, Uint8List buf) {
    return value.write(buf);
  }
}

class BadWordCountBip39Exception extends Bip39Exception {
  final int wordCount;
  BadWordCountBip39Exception(int this.wordCount);
  BadWordCountBip39Exception._(int this.wordCount);
  static LiftRetVal<BadWordCountBip39Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final wordCount_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final wordCount = wordCount_lifted.value;
    new_offset += wordCount_lifted.bytesRead;
    return LiftRetVal(BadWordCountBip39Exception._(wordCount), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(wordCount) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      wordCount,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "BadWordCountBip39Exception($wordCount)";
  }
}

class UnknownWordBip39Exception extends Bip39Exception {
  final int index;
  UnknownWordBip39Exception(int this.index);
  UnknownWordBip39Exception._(int this.index);
  static LiftRetVal<UnknownWordBip39Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final index_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final index = index_lifted.value;
    new_offset += index_lifted.bytesRead;
    return LiftRetVal(UnknownWordBip39Exception._(index), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(index) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      index,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "UnknownWordBip39Exception($index)";
  }
}

class BadEntropyBitCountBip39Exception extends Bip39Exception {
  final int bitCount;
  BadEntropyBitCountBip39Exception(int this.bitCount);
  BadEntropyBitCountBip39Exception._(int this.bitCount);
  static LiftRetVal<BadEntropyBitCountBip39Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final bitCount_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final bitCount = bitCount_lifted.value;
    new_offset += bitCount_lifted.bytesRead;
    return LiftRetVal(BadEntropyBitCountBip39Exception._(bitCount), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(bitCount) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      bitCount,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "BadEntropyBitCountBip39Exception($bitCount)";
  }
}

class InvalidChecksumBip39Exception extends Bip39Exception {
  InvalidChecksumBip39Exception();
  InvalidChecksumBip39Exception._();
  static LiftRetVal<InvalidChecksumBip39Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidChecksumBip39Exception._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidChecksumBip39Exception";
  }
}

class AmbiguousLanguagesBip39Exception extends Bip39Exception {
  final String languages;
  AmbiguousLanguagesBip39Exception(String this.languages);
  AmbiguousLanguagesBip39Exception._(String this.languages);
  static LiftRetVal<AmbiguousLanguagesBip39Exception> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final languages_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final languages = languages_lifted.value;
    new_offset += languages_lifted.bytesRead;
    return LiftRetVal(
      AmbiguousLanguagesBip39Exception._(languages),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(languages) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      languages,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "AmbiguousLanguagesBip39Exception($languages)";
  }
}

class Bip39ExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterBip39Exception.lift(errorBuf);
  }
}

final Bip39ExceptionErrorHandler bip39ExceptionErrorHandler =
    Bip39ExceptionErrorHandler();

abstract class CalculateFeeException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterCalculateFeeException {
  static CalculateFeeException lift(RustBuffer buffer) {
    return FfiConverterCalculateFeeException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<CalculateFeeException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return MissingTxOutCalculateFeeException.read(subview);
      case 2:
        return NegativeFeeCalculateFeeException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(CalculateFeeException value) {
    return value.lower();
  }

  static int allocationSize(CalculateFeeException value) {
    return value.allocationSize();
  }

  static int write(CalculateFeeException value, Uint8List buf) {
    return value.write(buf);
  }
}

class MissingTxOutCalculateFeeException extends CalculateFeeException {
  final List<OutPoint> outPoints;
  MissingTxOutCalculateFeeException(List<OutPoint> this.outPoints);
  MissingTxOutCalculateFeeException._(List<OutPoint> this.outPoints);
  static LiftRetVal<MissingTxOutCalculateFeeException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final outPoints_lifted = FfiConverterSequenceOutPoint.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final outPoints = outPoints_lifted.value;
    new_offset += outPoints_lifted.bytesRead;
    return LiftRetVal(
      MissingTxOutCalculateFeeException._(outPoints),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterSequenceOutPoint.allocationSize(outPoints) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterSequenceOutPoint.write(
      outPoints,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MissingTxOutCalculateFeeException($outPoints)";
  }
}

class NegativeFeeCalculateFeeException extends CalculateFeeException {
  final String amount;
  NegativeFeeCalculateFeeException(String this.amount);
  NegativeFeeCalculateFeeException._(String this.amount);
  static LiftRetVal<NegativeFeeCalculateFeeException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final amount_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final amount = amount_lifted.value;
    new_offset += amount_lifted.bytesRead;
    return LiftRetVal(NegativeFeeCalculateFeeException._(amount), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(amount) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      amount,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "NegativeFeeCalculateFeeException($amount)";
  }
}

class CalculateFeeExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterCalculateFeeException.lift(errorBuf);
  }
}

final CalculateFeeExceptionErrorHandler calculateFeeExceptionErrorHandler =
    CalculateFeeExceptionErrorHandler();

abstract class CannotConnectException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterCannotConnectException {
  static CannotConnectException lift(RustBuffer buffer) {
    return FfiConverterCannotConnectException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<CannotConnectException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return IncludeCannotConnectException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(CannotConnectException value) {
    return value.lower();
  }

  static int allocationSize(CannotConnectException value) {
    return value.allocationSize();
  }

  static int write(CannotConnectException value, Uint8List buf) {
    return value.write(buf);
  }
}

class IncludeCannotConnectException extends CannotConnectException {
  final int height;
  IncludeCannotConnectException(int this.height);
  IncludeCannotConnectException._(int this.height);
  static LiftRetVal<IncludeCannotConnectException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final height_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final height = height_lifted.value;
    new_offset += height_lifted.bytesRead;
    return LiftRetVal(IncludeCannotConnectException._(height), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(height) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      height,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "IncludeCannotConnectException($height)";
  }
}

class CannotConnectExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterCannotConnectException.lift(errorBuf);
  }
}

final CannotConnectExceptionErrorHandler cannotConnectExceptionErrorHandler =
    CannotConnectExceptionErrorHandler();

abstract class CbfException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterCbfException {
  static CbfException lift(RustBuffer buffer) {
    return FfiConverterCbfException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<CbfException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return NodeStoppedCbfException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(CbfException value) {
    return value.lower();
  }

  static int allocationSize(CbfException value) {
    return value.allocationSize();
  }

  static int write(CbfException value, Uint8List buf) {
    return value.write(buf);
  }
}

class NodeStoppedCbfException extends CbfException {
  NodeStoppedCbfException();
  NodeStoppedCbfException._();
  static LiftRetVal<NodeStoppedCbfException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NodeStoppedCbfException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NodeStoppedCbfException";
  }
}

class CbfExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterCbfException.lift(errorBuf);
  }
}

final CbfExceptionErrorHandler cbfExceptionErrorHandler =
    CbfExceptionErrorHandler();

abstract class ChainPosition {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterChainPosition {
  static ChainPosition lift(RustBuffer buffer) {
    return FfiConverterChainPosition.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<ChainPosition> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return ConfirmedChainPosition.read(subview);
      case 2:
        return UnconfirmedChainPosition.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(ChainPosition value) {
    return value.lower();
  }

  static int allocationSize(ChainPosition value) {
    return value.allocationSize();
  }

  static int write(ChainPosition value, Uint8List buf) {
    return value.write(buf);
  }
}

class ConfirmedChainPosition extends ChainPosition {
  final ConfirmationBlockTime confirmationBlockTime;
  final Txid? transitively;
  ConfirmedChainPosition({
    required ConfirmationBlockTime this.confirmationBlockTime,
    required Txid? this.transitively,
  });
  ConfirmedChainPosition._(
    ConfirmationBlockTime this.confirmationBlockTime,
    Txid? this.transitively,
  );
  static LiftRetVal<ConfirmedChainPosition> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final confirmationBlockTime_lifted = FfiConverterConfirmationBlockTime.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final confirmationBlockTime = confirmationBlockTime_lifted.value;
    new_offset += confirmationBlockTime_lifted.bytesRead;
    final transitively_lifted = FfiConverterOptionalTxid.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final transitively = transitively_lifted.value;
    new_offset += transitively_lifted.bytesRead;
    return LiftRetVal(
      ConfirmedChainPosition._(confirmationBlockTime, transitively),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterConfirmationBlockTime.allocationSize(
          confirmationBlockTime,
        ) +
        FfiConverterOptionalTxid.allocationSize(transitively) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterConfirmationBlockTime.write(
      confirmationBlockTime,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalTxid.write(
      transitively,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class UnconfirmedChainPosition extends ChainPosition {
  final int? timestamp;
  UnconfirmedChainPosition(int? this.timestamp);
  UnconfirmedChainPosition._(int? this.timestamp);
  static LiftRetVal<UnconfirmedChainPosition> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final timestamp_lifted = FfiConverterOptionalUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final timestamp = timestamp_lifted.value;
    new_offset += timestamp_lifted.bytesRead;
    return LiftRetVal(UnconfirmedChainPosition._(timestamp), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterOptionalUInt64.allocationSize(timestamp) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterOptionalUInt64.write(
      timestamp,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

enum ChangeSpendPolicy { changeAllowed, onlyChange, changeForbidden }

class FfiConverterChangeSpendPolicy {
  static LiftRetVal<ChangeSpendPolicy> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(ChangeSpendPolicy.changeAllowed, 4);
      case 2:
        return LiftRetVal(ChangeSpendPolicy.onlyChange, 4);
      case 3:
        return LiftRetVal(ChangeSpendPolicy.changeForbidden, 4);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static ChangeSpendPolicy lift(RustBuffer buffer) {
    return FfiConverterChangeSpendPolicy.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(ChangeSpendPolicy input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(ChangeSpendPolicy _value) {
    return 4;
  }

  static int write(ChangeSpendPolicy value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

abstract class CreateTxException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterCreateTxException {
  static CreateTxException lift(RustBuffer buffer) {
    return FfiConverterCreateTxException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<CreateTxException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return DescriptorCreateTxException.read(subview);
      case 2:
        return PolicyCreateTxException.read(subview);
      case 3:
        return SpendingPolicyRequiredCreateTxException.read(subview);
      case 4:
        return Version0CreateTxException.read(subview);
      case 5:
        return Version1CsvCreateTxException.read(subview);
      case 6:
        return LockTimeCreateTxException.read(subview);
      case 7:
        return RbfSequenceCsvCreateTxException.read(subview);
      case 8:
        return FeeTooLowCreateTxException.read(subview);
      case 9:
        return FeeRateTooLowCreateTxException.read(subview);
      case 10:
        return NoUtxosSelectedCreateTxException.read(subview);
      case 11:
        return OutputBelowDustLimitCreateTxException.read(subview);
      case 12:
        return ChangePolicyDescriptorCreateTxException.read(subview);
      case 13:
        return CoinSelectionCreateTxException.read(subview);
      case 14:
        return InsufficientFundsCreateTxException.read(subview);
      case 15:
        return NoRecipientsCreateTxException.read(subview);
      case 16:
        return PsbtCreateTxException.read(subview);
      case 17:
        return MissingKeyOriginCreateTxException.read(subview);
      case 18:
        return UnknownUtxoCreateTxException.read(subview);
      case 19:
        return MissingNonWitnessUtxoCreateTxException.read(subview);
      case 20:
        return MiniscriptPsbtCreateTxException.read(subview);
      case 21:
        return PushBytesExceptionCreateTxException.read(subview);
      case 22:
        return LockTimeConversionExceptionCreateTxException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(CreateTxException value) {
    return value.lower();
  }

  static int allocationSize(CreateTxException value) {
    return value.allocationSize();
  }

  static int write(CreateTxException value, Uint8List buf) {
    return value.write(buf);
  }
}

class DescriptorCreateTxException extends CreateTxException {
  final String errorMessage;
  DescriptorCreateTxException(String this.errorMessage);
  DescriptorCreateTxException._(String this.errorMessage);
  static LiftRetVal<DescriptorCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(DescriptorCreateTxException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "DescriptorCreateTxException($errorMessage)";
  }
}

class PolicyCreateTxException extends CreateTxException {
  final String errorMessage;
  PolicyCreateTxException(String this.errorMessage);
  PolicyCreateTxException._(String this.errorMessage);
  static LiftRetVal<PolicyCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(PolicyCreateTxException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PolicyCreateTxException($errorMessage)";
  }
}

class SpendingPolicyRequiredCreateTxException extends CreateTxException {
  final String kind;
  SpendingPolicyRequiredCreateTxException(String this.kind);
  SpendingPolicyRequiredCreateTxException._(String this.kind);
  static LiftRetVal<SpendingPolicyRequiredCreateTxException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final kind_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final kind = kind_lifted.value;
    new_offset += kind_lifted.bytesRead;
    return LiftRetVal(
      SpendingPolicyRequiredCreateTxException._(kind),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(kind) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      kind,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "SpendingPolicyRequiredCreateTxException($kind)";
  }
}

class Version0CreateTxException extends CreateTxException {
  Version0CreateTxException();
  Version0CreateTxException._();
  static LiftRetVal<Version0CreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(Version0CreateTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "Version0CreateTxException";
  }
}

class Version1CsvCreateTxException extends CreateTxException {
  Version1CsvCreateTxException();
  Version1CsvCreateTxException._();
  static LiftRetVal<Version1CsvCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(Version1CsvCreateTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "Version1CsvCreateTxException";
  }
}

class LockTimeCreateTxException extends CreateTxException {
  final String requested;
  final String required_;
  LockTimeCreateTxException({
    required String this.requested,
    required String this.required_,
  });
  LockTimeCreateTxException._(String this.requested, String this.required_);
  static LiftRetVal<LockTimeCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final requested_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final requested = requested_lifted.value;
    new_offset += requested_lifted.bytesRead;
    final required__lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final required_ = required__lifted.value;
    new_offset += required__lifted.bytesRead;
    return LiftRetVal(
      LockTimeCreateTxException._(requested, required_),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(requested) +
        FfiConverterString.allocationSize(required_) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      requested,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterString.write(
      required_,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "LockTimeCreateTxException($requested, $required_)";
  }
}

class RbfSequenceCsvCreateTxException extends CreateTxException {
  final String sequence;
  final String csv;
  RbfSequenceCsvCreateTxException({
    required String this.sequence,
    required String this.csv,
  });
  RbfSequenceCsvCreateTxException._(String this.sequence, String this.csv);
  static LiftRetVal<RbfSequenceCsvCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sequence_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final sequence = sequence_lifted.value;
    new_offset += sequence_lifted.bytesRead;
    final csv_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final csv = csv_lifted.value;
    new_offset += csv_lifted.bytesRead;
    return LiftRetVal(
      RbfSequenceCsvCreateTxException._(sequence, csv),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(sequence) +
        FfiConverterString.allocationSize(csv) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      sequence,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterString.write(
      csv,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "RbfSequenceCsvCreateTxException($sequence, $csv)";
  }
}

class FeeTooLowCreateTxException extends CreateTxException {
  final String required_;
  FeeTooLowCreateTxException(String this.required_);
  FeeTooLowCreateTxException._(String this.required_);
  static LiftRetVal<FeeTooLowCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final required__lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final required_ = required__lifted.value;
    new_offset += required__lifted.bytesRead;
    return LiftRetVal(FeeTooLowCreateTxException._(required_), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(required_) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      required_,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "FeeTooLowCreateTxException($required_)";
  }
}

class FeeRateTooLowCreateTxException extends CreateTxException {
  final String required_;
  FeeRateTooLowCreateTxException(String this.required_);
  FeeRateTooLowCreateTxException._(String this.required_);
  static LiftRetVal<FeeRateTooLowCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final required__lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final required_ = required__lifted.value;
    new_offset += required__lifted.bytesRead;
    return LiftRetVal(FeeRateTooLowCreateTxException._(required_), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(required_) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      required_,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "FeeRateTooLowCreateTxException($required_)";
  }
}

class NoUtxosSelectedCreateTxException extends CreateTxException {
  NoUtxosSelectedCreateTxException();
  NoUtxosSelectedCreateTxException._();
  static LiftRetVal<NoUtxosSelectedCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NoUtxosSelectedCreateTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NoUtxosSelectedCreateTxException";
  }
}

class OutputBelowDustLimitCreateTxException extends CreateTxException {
  final int index;
  OutputBelowDustLimitCreateTxException(int this.index);
  OutputBelowDustLimitCreateTxException._(int this.index);
  static LiftRetVal<OutputBelowDustLimitCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final index_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final index = index_lifted.value;
    new_offset += index_lifted.bytesRead;
    return LiftRetVal(
      OutputBelowDustLimitCreateTxException._(index),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(index) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 11);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      index,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "OutputBelowDustLimitCreateTxException($index)";
  }
}

class ChangePolicyDescriptorCreateTxException extends CreateTxException {
  ChangePolicyDescriptorCreateTxException();
  ChangePolicyDescriptorCreateTxException._();
  static LiftRetVal<ChangePolicyDescriptorCreateTxException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(ChangePolicyDescriptorCreateTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 12);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "ChangePolicyDescriptorCreateTxException";
  }
}

class CoinSelectionCreateTxException extends CreateTxException {
  final String errorMessage;
  CoinSelectionCreateTxException(String this.errorMessage);
  CoinSelectionCreateTxException._(String this.errorMessage);
  static LiftRetVal<CoinSelectionCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      CoinSelectionCreateTxException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 13);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "CoinSelectionCreateTxException($errorMessage)";
  }
}

class InsufficientFundsCreateTxException extends CreateTxException {
  final int needed;
  final int available;
  InsufficientFundsCreateTxException({
    required int this.needed,
    required int this.available,
  });
  InsufficientFundsCreateTxException._(int this.needed, int this.available);
  static LiftRetVal<InsufficientFundsCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final needed_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final needed = needed_lifted.value;
    new_offset += needed_lifted.bytesRead;
    final available_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final available = available_lifted.value;
    new_offset += available_lifted.bytesRead;
    return LiftRetVal(
      InsufficientFundsCreateTxException._(needed, available),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(needed) +
        FfiConverterUInt64.allocationSize(available) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 14);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      needed,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      available,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InsufficientFundsCreateTxException($needed, $available)";
  }
}

class NoRecipientsCreateTxException extends CreateTxException {
  NoRecipientsCreateTxException();
  NoRecipientsCreateTxException._();
  static LiftRetVal<NoRecipientsCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NoRecipientsCreateTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 15);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NoRecipientsCreateTxException";
  }
}

class PsbtCreateTxException extends CreateTxException {
  final String errorMessage;
  PsbtCreateTxException(String this.errorMessage);
  PsbtCreateTxException._(String this.errorMessage);
  static LiftRetVal<PsbtCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(PsbtCreateTxException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 16);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PsbtCreateTxException($errorMessage)";
  }
}

class MissingKeyOriginCreateTxException extends CreateTxException {
  final String key;
  MissingKeyOriginCreateTxException(String this.key);
  MissingKeyOriginCreateTxException._(String this.key);
  static LiftRetVal<MissingKeyOriginCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final key_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final key = key_lifted.value;
    new_offset += key_lifted.bytesRead;
    return LiftRetVal(MissingKeyOriginCreateTxException._(key), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(key) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 17);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      key,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MissingKeyOriginCreateTxException($key)";
  }
}

class UnknownUtxoCreateTxException extends CreateTxException {
  final String outpoint;
  UnknownUtxoCreateTxException(String this.outpoint);
  UnknownUtxoCreateTxException._(String this.outpoint);
  static LiftRetVal<UnknownUtxoCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final outpoint_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final outpoint = outpoint_lifted.value;
    new_offset += outpoint_lifted.bytesRead;
    return LiftRetVal(UnknownUtxoCreateTxException._(outpoint), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(outpoint) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 18);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      outpoint,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "UnknownUtxoCreateTxException($outpoint)";
  }
}

class MissingNonWitnessUtxoCreateTxException extends CreateTxException {
  final String outpoint;
  MissingNonWitnessUtxoCreateTxException(String this.outpoint);
  MissingNonWitnessUtxoCreateTxException._(String this.outpoint);
  static LiftRetVal<MissingNonWitnessUtxoCreateTxException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final outpoint_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final outpoint = outpoint_lifted.value;
    new_offset += outpoint_lifted.bytesRead;
    return LiftRetVal(
      MissingNonWitnessUtxoCreateTxException._(outpoint),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(outpoint) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 19);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      outpoint,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MissingNonWitnessUtxoCreateTxException($outpoint)";
  }
}

class MiniscriptPsbtCreateTxException extends CreateTxException {
  final String errorMessage;
  MiniscriptPsbtCreateTxException(String this.errorMessage);
  MiniscriptPsbtCreateTxException._(String this.errorMessage);
  static LiftRetVal<MiniscriptPsbtCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      MiniscriptPsbtCreateTxException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 20);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MiniscriptPsbtCreateTxException($errorMessage)";
  }
}

class PushBytesExceptionCreateTxException extends CreateTxException {
  PushBytesExceptionCreateTxException();
  PushBytesExceptionCreateTxException._();
  static LiftRetVal<PushBytesExceptionCreateTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(PushBytesExceptionCreateTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 21);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "PushBytesExceptionCreateTxException";
  }
}

class LockTimeConversionExceptionCreateTxException extends CreateTxException {
  LockTimeConversionExceptionCreateTxException();
  LockTimeConversionExceptionCreateTxException._();
  static LiftRetVal<LockTimeConversionExceptionCreateTxException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      LockTimeConversionExceptionCreateTxException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 22);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "LockTimeConversionExceptionCreateTxException";
  }
}

class CreateTxExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterCreateTxException.lift(errorBuf);
  }
}

final CreateTxExceptionErrorHandler createTxExceptionErrorHandler =
    CreateTxExceptionErrorHandler();

abstract class CreateWithPersistException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterCreateWithPersistException {
  static CreateWithPersistException lift(RustBuffer buffer) {
    return FfiConverterCreateWithPersistException.read(
      buffer.asUint8List(),
    ).value;
  }

  static LiftRetVal<CreateWithPersistException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return PersistCreateWithPersistException.read(subview);
      case 2:
        return DataAlreadyExistsCreateWithPersistException.read(subview);
      case 3:
        return DescriptorCreateWithPersistException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(CreateWithPersistException value) {
    return value.lower();
  }

  static int allocationSize(CreateWithPersistException value) {
    return value.allocationSize();
  }

  static int write(CreateWithPersistException value, Uint8List buf) {
    return value.write(buf);
  }
}

class PersistCreateWithPersistException extends CreateWithPersistException {
  final String errorMessage;
  PersistCreateWithPersistException(String this.errorMessage);
  PersistCreateWithPersistException._(String this.errorMessage);
  static LiftRetVal<PersistCreateWithPersistException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      PersistCreateWithPersistException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PersistCreateWithPersistException($errorMessage)";
  }
}

class DataAlreadyExistsCreateWithPersistException
    extends CreateWithPersistException {
  DataAlreadyExistsCreateWithPersistException();
  DataAlreadyExistsCreateWithPersistException._();
  static LiftRetVal<DataAlreadyExistsCreateWithPersistException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      DataAlreadyExistsCreateWithPersistException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "DataAlreadyExistsCreateWithPersistException";
  }
}

class DescriptorCreateWithPersistException extends CreateWithPersistException {
  final String errorMessage;
  DescriptorCreateWithPersistException(String this.errorMessage);
  DescriptorCreateWithPersistException._(String this.errorMessage);
  static LiftRetVal<DescriptorCreateWithPersistException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      DescriptorCreateWithPersistException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "DescriptorCreateWithPersistException($errorMessage)";
  }
}

class CreateWithPersistExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterCreateWithPersistException.lift(errorBuf);
  }
}

final CreateWithPersistExceptionErrorHandler
createWithPersistExceptionErrorHandler =
    CreateWithPersistExceptionErrorHandler();

abstract class DescriptorException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterDescriptorException {
  static DescriptorException lift(RustBuffer buffer) {
    return FfiConverterDescriptorException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<DescriptorException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return InvalidHdKeyPathDescriptorException.read(subview);
      case 2:
        return InvalidDescriptorChecksumDescriptorException.read(subview);
      case 3:
        return HardenedDerivationXpubDescriptorException.read(subview);
      case 4:
        return MultiPathDescriptorException.read(subview);
      case 5:
        return KeyDescriptorException.read(subview);
      case 6:
        return PolicyDescriptorException.read(subview);
      case 7:
        return InvalidDescriptorCharacterDescriptorException.read(subview);
      case 8:
        return Bip32DescriptorException.read(subview);
      case 9:
        return Base58DescriptorException.read(subview);
      case 10:
        return PkDescriptorException.read(subview);
      case 11:
        return MiniscriptDescriptorException.read(subview);
      case 12:
        return HexDescriptorException.read(subview);
      case 13:
        return ExternalAndInternalAreTheSameDescriptorException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(DescriptorException value) {
    return value.lower();
  }

  static int allocationSize(DescriptorException value) {
    return value.allocationSize();
  }

  static int write(DescriptorException value, Uint8List buf) {
    return value.write(buf);
  }
}

class InvalidHdKeyPathDescriptorException extends DescriptorException {
  InvalidHdKeyPathDescriptorException();
  InvalidHdKeyPathDescriptorException._();
  static LiftRetVal<InvalidHdKeyPathDescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidHdKeyPathDescriptorException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidHdKeyPathDescriptorException";
  }
}

class InvalidDescriptorChecksumDescriptorException extends DescriptorException {
  InvalidDescriptorChecksumDescriptorException();
  InvalidDescriptorChecksumDescriptorException._();
  static LiftRetVal<InvalidDescriptorChecksumDescriptorException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      InvalidDescriptorChecksumDescriptorException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidDescriptorChecksumDescriptorException";
  }
}

class HardenedDerivationXpubDescriptorException extends DescriptorException {
  HardenedDerivationXpubDescriptorException();
  HardenedDerivationXpubDescriptorException._();
  static LiftRetVal<HardenedDerivationXpubDescriptorException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      HardenedDerivationXpubDescriptorException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "HardenedDerivationXpubDescriptorException";
  }
}

class MultiPathDescriptorException extends DescriptorException {
  MultiPathDescriptorException();
  MultiPathDescriptorException._();
  static LiftRetVal<MultiPathDescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MultiPathDescriptorException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MultiPathDescriptorException";
  }
}

class KeyDescriptorException extends DescriptorException {
  final String errorMessage;
  KeyDescriptorException(String this.errorMessage);
  KeyDescriptorException._(String this.errorMessage);
  static LiftRetVal<KeyDescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(KeyDescriptorException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "KeyDescriptorException($errorMessage)";
  }
}

class PolicyDescriptorException extends DescriptorException {
  final String errorMessage;
  PolicyDescriptorException(String this.errorMessage);
  PolicyDescriptorException._(String this.errorMessage);
  static LiftRetVal<PolicyDescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(PolicyDescriptorException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PolicyDescriptorException($errorMessage)";
  }
}

class InvalidDescriptorCharacterDescriptorException
    extends DescriptorException {
  final String char;
  InvalidDescriptorCharacterDescriptorException(String this.char);
  InvalidDescriptorCharacterDescriptorException._(String this.char);
  static LiftRetVal<InvalidDescriptorCharacterDescriptorException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final char_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final char = char_lifted.value;
    new_offset += char_lifted.bytesRead;
    return LiftRetVal(
      InvalidDescriptorCharacterDescriptorException._(char),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(char) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      char,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidDescriptorCharacterDescriptorException($char)";
  }
}

class Bip32DescriptorException extends DescriptorException {
  final String errorMessage;
  Bip32DescriptorException(String this.errorMessage);
  Bip32DescriptorException._(String this.errorMessage);
  static LiftRetVal<Bip32DescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(Bip32DescriptorException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "Bip32DescriptorException($errorMessage)";
  }
}

class Base58DescriptorException extends DescriptorException {
  final String errorMessage;
  Base58DescriptorException(String this.errorMessage);
  Base58DescriptorException._(String this.errorMessage);
  static LiftRetVal<Base58DescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(Base58DescriptorException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "Base58DescriptorException($errorMessage)";
  }
}

class PkDescriptorException extends DescriptorException {
  final String errorMessage;
  PkDescriptorException(String this.errorMessage);
  PkDescriptorException._(String this.errorMessage);
  static LiftRetVal<PkDescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(PkDescriptorException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PkDescriptorException($errorMessage)";
  }
}

class MiniscriptDescriptorException extends DescriptorException {
  final String errorMessage;
  MiniscriptDescriptorException(String this.errorMessage);
  MiniscriptDescriptorException._(String this.errorMessage);
  static LiftRetVal<MiniscriptDescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      MiniscriptDescriptorException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 11);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MiniscriptDescriptorException($errorMessage)";
  }
}

class HexDescriptorException extends DescriptorException {
  final String errorMessage;
  HexDescriptorException(String this.errorMessage);
  HexDescriptorException._(String this.errorMessage);
  static LiftRetVal<HexDescriptorException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(HexDescriptorException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 12);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "HexDescriptorException($errorMessage)";
  }
}

class ExternalAndInternalAreTheSameDescriptorException
    extends DescriptorException {
  ExternalAndInternalAreTheSameDescriptorException();
  ExternalAndInternalAreTheSameDescriptorException._();
  static LiftRetVal<ExternalAndInternalAreTheSameDescriptorException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      ExternalAndInternalAreTheSameDescriptorException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 13);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "ExternalAndInternalAreTheSameDescriptorException";
  }
}

class DescriptorExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterDescriptorException.lift(errorBuf);
  }
}

final DescriptorExceptionErrorHandler descriptorExceptionErrorHandler =
    DescriptorExceptionErrorHandler();

abstract class DescriptorKeyException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterDescriptorKeyException {
  static DescriptorKeyException lift(RustBuffer buffer) {
    return FfiConverterDescriptorKeyException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<DescriptorKeyException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return ParseDescriptorKeyException.read(subview);
      case 2:
        return InvalidKeyTypeDescriptorKeyException.read(subview);
      case 3:
        return Bip32DescriptorKeyException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(DescriptorKeyException value) {
    return value.lower();
  }

  static int allocationSize(DescriptorKeyException value) {
    return value.allocationSize();
  }

  static int write(DescriptorKeyException value, Uint8List buf) {
    return value.write(buf);
  }
}

class ParseDescriptorKeyException extends DescriptorKeyException {
  final String errorMessage;
  ParseDescriptorKeyException(String this.errorMessage);
  ParseDescriptorKeyException._(String this.errorMessage);
  static LiftRetVal<ParseDescriptorKeyException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(ParseDescriptorKeyException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ParseDescriptorKeyException($errorMessage)";
  }
}

class InvalidKeyTypeDescriptorKeyException extends DescriptorKeyException {
  InvalidKeyTypeDescriptorKeyException();
  InvalidKeyTypeDescriptorKeyException._();
  static LiftRetVal<InvalidKeyTypeDescriptorKeyException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidKeyTypeDescriptorKeyException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidKeyTypeDescriptorKeyException";
  }
}

class Bip32DescriptorKeyException extends DescriptorKeyException {
  final String errorMessage;
  Bip32DescriptorKeyException(String this.errorMessage);
  Bip32DescriptorKeyException._(String this.errorMessage);
  static LiftRetVal<Bip32DescriptorKeyException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(Bip32DescriptorKeyException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "Bip32DescriptorKeyException($errorMessage)";
  }
}

class DescriptorKeyExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterDescriptorKeyException.lift(errorBuf);
  }
}

final DescriptorKeyExceptionErrorHandler descriptorKeyExceptionErrorHandler =
    DescriptorKeyExceptionErrorHandler();

enum DescriptorType {
  bare,
  sh,
  pkh,
  wpkh,
  wsh,
  shWsh,
  shWpkh,
  shSortedMulti,
  wshSortedMulti,
  shWshSortedMulti,
  tr,
}

class FfiConverterDescriptorType {
  static LiftRetVal<DescriptorType> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(DescriptorType.bare, 4);
      case 2:
        return LiftRetVal(DescriptorType.sh, 4);
      case 3:
        return LiftRetVal(DescriptorType.pkh, 4);
      case 4:
        return LiftRetVal(DescriptorType.wpkh, 4);
      case 5:
        return LiftRetVal(DescriptorType.wsh, 4);
      case 6:
        return LiftRetVal(DescriptorType.shWsh, 4);
      case 7:
        return LiftRetVal(DescriptorType.shWpkh, 4);
      case 8:
        return LiftRetVal(DescriptorType.shSortedMulti, 4);
      case 9:
        return LiftRetVal(DescriptorType.wshSortedMulti, 4);
      case 10:
        return LiftRetVal(DescriptorType.shWshSortedMulti, 4);
      case 11:
        return LiftRetVal(DescriptorType.tr, 4);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static DescriptorType lift(RustBuffer buffer) {
    return FfiConverterDescriptorType.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(DescriptorType input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(DescriptorType _value) {
    return 4;
  }

  static int write(DescriptorType value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

abstract class ElectrumException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterElectrumException {
  static ElectrumException lift(RustBuffer buffer) {
    return FfiConverterElectrumException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<ElectrumException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return IoExceptionElectrumException.read(subview);
      case 2:
        return JsonElectrumException.read(subview);
      case 3:
        return HexElectrumException.read(subview);
      case 4:
        return ProtocolElectrumException.read(subview);
      case 5:
        return BitcoinElectrumException.read(subview);
      case 6:
        return AlreadySubscribedElectrumException.read(subview);
      case 7:
        return NotSubscribedElectrumException.read(subview);
      case 8:
        return InvalidResponseElectrumException.read(subview);
      case 9:
        return MessageElectrumException.read(subview);
      case 10:
        return InvalidDnsNameExceptionElectrumException.read(subview);
      case 11:
        return MissingDomainElectrumException.read(subview);
      case 12:
        return AllAttemptsErroredElectrumException.read(subview);
      case 13:
        return SharedIoExceptionElectrumException.read(subview);
      case 14:
        return CouldntLockReaderElectrumException.read(subview);
      case 15:
        return MpscElectrumException.read(subview);
      case 16:
        return CouldNotCreateConnectionElectrumException.read(subview);
      case 17:
        return RequestAlreadyConsumedElectrumException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(ElectrumException value) {
    return value.lower();
  }

  static int allocationSize(ElectrumException value) {
    return value.allocationSize();
  }

  static int write(ElectrumException value, Uint8List buf) {
    return value.write(buf);
  }
}

class IoExceptionElectrumException extends ElectrumException {
  final String errorMessage;
  IoExceptionElectrumException(String this.errorMessage);
  IoExceptionElectrumException._(String this.errorMessage);
  static LiftRetVal<IoExceptionElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(IoExceptionElectrumException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "IoExceptionElectrumException($errorMessage)";
  }
}

class JsonElectrumException extends ElectrumException {
  final String errorMessage;
  JsonElectrumException(String this.errorMessage);
  JsonElectrumException._(String this.errorMessage);
  static LiftRetVal<JsonElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(JsonElectrumException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "JsonElectrumException($errorMessage)";
  }
}

class HexElectrumException extends ElectrumException {
  final String errorMessage;
  HexElectrumException(String this.errorMessage);
  HexElectrumException._(String this.errorMessage);
  static LiftRetVal<HexElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(HexElectrumException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "HexElectrumException($errorMessage)";
  }
}

class ProtocolElectrumException extends ElectrumException {
  final String errorMessage;
  ProtocolElectrumException(String this.errorMessage);
  ProtocolElectrumException._(String this.errorMessage);
  static LiftRetVal<ProtocolElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(ProtocolElectrumException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ProtocolElectrumException($errorMessage)";
  }
}

class BitcoinElectrumException extends ElectrumException {
  final String errorMessage;
  BitcoinElectrumException(String this.errorMessage);
  BitcoinElectrumException._(String this.errorMessage);
  static LiftRetVal<BitcoinElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(BitcoinElectrumException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "BitcoinElectrumException($errorMessage)";
  }
}

class AlreadySubscribedElectrumException extends ElectrumException {
  AlreadySubscribedElectrumException();
  AlreadySubscribedElectrumException._();
  static LiftRetVal<AlreadySubscribedElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(AlreadySubscribedElectrumException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "AlreadySubscribedElectrumException";
  }
}

class NotSubscribedElectrumException extends ElectrumException {
  NotSubscribedElectrumException();
  NotSubscribedElectrumException._();
  static LiftRetVal<NotSubscribedElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NotSubscribedElectrumException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NotSubscribedElectrumException";
  }
}

class InvalidResponseElectrumException extends ElectrumException {
  final String errorMessage;
  InvalidResponseElectrumException(String this.errorMessage);
  InvalidResponseElectrumException._(String this.errorMessage);
  static LiftRetVal<InvalidResponseElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      InvalidResponseElectrumException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidResponseElectrumException($errorMessage)";
  }
}

class MessageElectrumException extends ElectrumException {
  final String errorMessage;
  MessageElectrumException(String this.errorMessage);
  MessageElectrumException._(String this.errorMessage);
  static LiftRetVal<MessageElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(MessageElectrumException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MessageElectrumException($errorMessage)";
  }
}

class InvalidDnsNameExceptionElectrumException extends ElectrumException {
  final String domain;
  InvalidDnsNameExceptionElectrumException(String this.domain);
  InvalidDnsNameExceptionElectrumException._(String this.domain);
  static LiftRetVal<InvalidDnsNameExceptionElectrumException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final domain_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final domain = domain_lifted.value;
    new_offset += domain_lifted.bytesRead;
    return LiftRetVal(
      InvalidDnsNameExceptionElectrumException._(domain),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(domain) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      domain,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidDnsNameExceptionElectrumException($domain)";
  }
}

class MissingDomainElectrumException extends ElectrumException {
  MissingDomainElectrumException();
  MissingDomainElectrumException._();
  static LiftRetVal<MissingDomainElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingDomainElectrumException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 11);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingDomainElectrumException";
  }
}

class AllAttemptsErroredElectrumException extends ElectrumException {
  AllAttemptsErroredElectrumException();
  AllAttemptsErroredElectrumException._();
  static LiftRetVal<AllAttemptsErroredElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(AllAttemptsErroredElectrumException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 12);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "AllAttemptsErroredElectrumException";
  }
}

class SharedIoExceptionElectrumException extends ElectrumException {
  final String errorMessage;
  SharedIoExceptionElectrumException(String this.errorMessage);
  SharedIoExceptionElectrumException._(String this.errorMessage);
  static LiftRetVal<SharedIoExceptionElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      SharedIoExceptionElectrumException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 13);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "SharedIoExceptionElectrumException($errorMessage)";
  }
}

class CouldntLockReaderElectrumException extends ElectrumException {
  CouldntLockReaderElectrumException();
  CouldntLockReaderElectrumException._();
  static LiftRetVal<CouldntLockReaderElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(CouldntLockReaderElectrumException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 14);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "CouldntLockReaderElectrumException";
  }
}

class MpscElectrumException extends ElectrumException {
  MpscElectrumException();
  MpscElectrumException._();
  static LiftRetVal<MpscElectrumException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MpscElectrumException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 15);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MpscElectrumException";
  }
}

class CouldNotCreateConnectionElectrumException extends ElectrumException {
  final String errorMessage;
  CouldNotCreateConnectionElectrumException(String this.errorMessage);
  CouldNotCreateConnectionElectrumException._(String this.errorMessage);
  static LiftRetVal<CouldNotCreateConnectionElectrumException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      CouldNotCreateConnectionElectrumException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 16);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "CouldNotCreateConnectionElectrumException($errorMessage)";
  }
}

class RequestAlreadyConsumedElectrumException extends ElectrumException {
  RequestAlreadyConsumedElectrumException();
  RequestAlreadyConsumedElectrumException._();
  static LiftRetVal<RequestAlreadyConsumedElectrumException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(RequestAlreadyConsumedElectrumException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 17);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "RequestAlreadyConsumedElectrumException";
  }
}

class ElectrumExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterElectrumException.lift(errorBuf);
  }
}

final ElectrumExceptionErrorHandler electrumExceptionErrorHandler =
    ElectrumExceptionErrorHandler();

abstract class EsploraException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterEsploraException {
  static EsploraException lift(RustBuffer buffer) {
    return FfiConverterEsploraException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<EsploraException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return MinreqEsploraException.read(subview);
      case 2:
        return HttpResponseEsploraException.read(subview);
      case 3:
        return ParsingEsploraException.read(subview);
      case 4:
        return StatusCodeEsploraException.read(subview);
      case 5:
        return BitcoinEncodingEsploraException.read(subview);
      case 6:
        return HexToArrayEsploraException.read(subview);
      case 7:
        return HexToBytesEsploraException.read(subview);
      case 8:
        return TransactionNotFoundEsploraException.read(subview);
      case 9:
        return HeaderHeightNotFoundEsploraException.read(subview);
      case 10:
        return HeaderHashNotFoundEsploraException.read(subview);
      case 11:
        return InvalidHttpHeaderNameEsploraException.read(subview);
      case 12:
        return InvalidHttpHeaderValueEsploraException.read(subview);
      case 13:
        return RequestAlreadyConsumedEsploraException.read(subview);
      case 14:
        return InvalidResponseEsploraException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(EsploraException value) {
    return value.lower();
  }

  static int allocationSize(EsploraException value) {
    return value.allocationSize();
  }

  static int write(EsploraException value, Uint8List buf) {
    return value.write(buf);
  }
}

class MinreqEsploraException extends EsploraException {
  final String errorMessage;
  MinreqEsploraException(String this.errorMessage);
  MinreqEsploraException._(String this.errorMessage);
  static LiftRetVal<MinreqEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(MinreqEsploraException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MinreqEsploraException($errorMessage)";
  }
}

class HttpResponseEsploraException extends EsploraException {
  final int status;
  final String errorMessage;
  HttpResponseEsploraException({
    required int this.status,
    required String this.errorMessage,
  });
  HttpResponseEsploraException._(int this.status, String this.errorMessage);
  static LiftRetVal<HttpResponseEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final status_lifted = FfiConverterUInt16.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final status = status_lifted.value;
    new_offset += status_lifted.bytesRead;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      HttpResponseEsploraException._(status, errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt16.allocationSize(status) +
        FfiConverterString.allocationSize(errorMessage) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt16.write(
      status,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "HttpResponseEsploraException($status, $errorMessage)";
  }
}

class ParsingEsploraException extends EsploraException {
  final String errorMessage;
  ParsingEsploraException(String this.errorMessage);
  ParsingEsploraException._(String this.errorMessage);
  static LiftRetVal<ParsingEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(ParsingEsploraException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ParsingEsploraException($errorMessage)";
  }
}

class StatusCodeEsploraException extends EsploraException {
  final String errorMessage;
  StatusCodeEsploraException(String this.errorMessage);
  StatusCodeEsploraException._(String this.errorMessage);
  static LiftRetVal<StatusCodeEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(StatusCodeEsploraException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "StatusCodeEsploraException($errorMessage)";
  }
}

class BitcoinEncodingEsploraException extends EsploraException {
  final String errorMessage;
  BitcoinEncodingEsploraException(String this.errorMessage);
  BitcoinEncodingEsploraException._(String this.errorMessage);
  static LiftRetVal<BitcoinEncodingEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      BitcoinEncodingEsploraException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "BitcoinEncodingEsploraException($errorMessage)";
  }
}

class HexToArrayEsploraException extends EsploraException {
  final String errorMessage;
  HexToArrayEsploraException(String this.errorMessage);
  HexToArrayEsploraException._(String this.errorMessage);
  static LiftRetVal<HexToArrayEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(HexToArrayEsploraException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "HexToArrayEsploraException($errorMessage)";
  }
}

class HexToBytesEsploraException extends EsploraException {
  final String errorMessage;
  HexToBytesEsploraException(String this.errorMessage);
  HexToBytesEsploraException._(String this.errorMessage);
  static LiftRetVal<HexToBytesEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(HexToBytesEsploraException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "HexToBytesEsploraException($errorMessage)";
  }
}

class TransactionNotFoundEsploraException extends EsploraException {
  TransactionNotFoundEsploraException();
  TransactionNotFoundEsploraException._();
  static LiftRetVal<TransactionNotFoundEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(TransactionNotFoundEsploraException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "TransactionNotFoundEsploraException";
  }
}

class HeaderHeightNotFoundEsploraException extends EsploraException {
  final int height;
  HeaderHeightNotFoundEsploraException(int this.height);
  HeaderHeightNotFoundEsploraException._(int this.height);
  static LiftRetVal<HeaderHeightNotFoundEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final height_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final height = height_lifted.value;
    new_offset += height_lifted.bytesRead;
    return LiftRetVal(
      HeaderHeightNotFoundEsploraException._(height),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(height) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      height,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "HeaderHeightNotFoundEsploraException($height)";
  }
}

class HeaderHashNotFoundEsploraException extends EsploraException {
  HeaderHashNotFoundEsploraException();
  HeaderHashNotFoundEsploraException._();
  static LiftRetVal<HeaderHashNotFoundEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(HeaderHashNotFoundEsploraException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "HeaderHashNotFoundEsploraException";
  }
}

class InvalidHttpHeaderNameEsploraException extends EsploraException {
  final String name;
  InvalidHttpHeaderNameEsploraException(String this.name);
  InvalidHttpHeaderNameEsploraException._(String this.name);
  static LiftRetVal<InvalidHttpHeaderNameEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final name_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final name = name_lifted.value;
    new_offset += name_lifted.bytesRead;
    return LiftRetVal(
      InvalidHttpHeaderNameEsploraException._(name),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(name) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 11);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      name,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidHttpHeaderNameEsploraException($name)";
  }
}

class InvalidHttpHeaderValueEsploraException extends EsploraException {
  final String value;
  InvalidHttpHeaderValueEsploraException(String this.value);
  InvalidHttpHeaderValueEsploraException._(String this.value);
  static LiftRetVal<InvalidHttpHeaderValueEsploraException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final value_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final value = value_lifted.value;
    new_offset += value_lifted.bytesRead;
    return LiftRetVal(
      InvalidHttpHeaderValueEsploraException._(value),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(value) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 12);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      value,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidHttpHeaderValueEsploraException($value)";
  }
}

class RequestAlreadyConsumedEsploraException extends EsploraException {
  RequestAlreadyConsumedEsploraException();
  RequestAlreadyConsumedEsploraException._();
  static LiftRetVal<RequestAlreadyConsumedEsploraException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(RequestAlreadyConsumedEsploraException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 13);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "RequestAlreadyConsumedEsploraException";
  }
}

class InvalidResponseEsploraException extends EsploraException {
  InvalidResponseEsploraException();
  InvalidResponseEsploraException._();
  static LiftRetVal<InvalidResponseEsploraException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidResponseEsploraException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 14);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidResponseEsploraException";
  }
}

class EsploraExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterEsploraException.lift(errorBuf);
  }
}

final EsploraExceptionErrorHandler esploraExceptionErrorHandler =
    EsploraExceptionErrorHandler();

abstract class ExtractTxException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterExtractTxException {
  static ExtractTxException lift(RustBuffer buffer) {
    return FfiConverterExtractTxException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<ExtractTxException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return AbsurdFeeRateExtractTxException.read(subview);
      case 2:
        return MissingInputValueExtractTxException.read(subview);
      case 3:
        return SendingTooMuchExtractTxException.read(subview);
      case 4:
        return OtherExtractTxErrExtractTxException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(ExtractTxException value) {
    return value.lower();
  }

  static int allocationSize(ExtractTxException value) {
    return value.allocationSize();
  }

  static int write(ExtractTxException value, Uint8List buf) {
    return value.write(buf);
  }
}

class AbsurdFeeRateExtractTxException extends ExtractTxException {
  final int feeRate;
  AbsurdFeeRateExtractTxException(int this.feeRate);
  AbsurdFeeRateExtractTxException._(int this.feeRate);
  static LiftRetVal<AbsurdFeeRateExtractTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final feeRate_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final feeRate = feeRate_lifted.value;
    new_offset += feeRate_lifted.bytesRead;
    return LiftRetVal(AbsurdFeeRateExtractTxException._(feeRate), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(feeRate) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      feeRate,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "AbsurdFeeRateExtractTxException($feeRate)";
  }
}

class MissingInputValueExtractTxException extends ExtractTxException {
  MissingInputValueExtractTxException();
  MissingInputValueExtractTxException._();
  static LiftRetVal<MissingInputValueExtractTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingInputValueExtractTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingInputValueExtractTxException";
  }
}

class SendingTooMuchExtractTxException extends ExtractTxException {
  SendingTooMuchExtractTxException();
  SendingTooMuchExtractTxException._();
  static LiftRetVal<SendingTooMuchExtractTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(SendingTooMuchExtractTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "SendingTooMuchExtractTxException";
  }
}

class OtherExtractTxErrExtractTxException extends ExtractTxException {
  OtherExtractTxErrExtractTxException();
  OtherExtractTxErrExtractTxException._();
  static LiftRetVal<OtherExtractTxErrExtractTxException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(OtherExtractTxErrExtractTxException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "OtherExtractTxErrExtractTxException";
  }
}

class ExtractTxExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterExtractTxException.lift(errorBuf);
  }
}

final ExtractTxExceptionErrorHandler extractTxExceptionErrorHandler =
    ExtractTxExceptionErrorHandler();

abstract class FeeRateException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterFeeRateException {
  static FeeRateException lift(RustBuffer buffer) {
    return FfiConverterFeeRateException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<FeeRateException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return ArithmeticOverflowFeeRateException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(FeeRateException value) {
    return value.lower();
  }

  static int allocationSize(FeeRateException value) {
    return value.allocationSize();
  }

  static int write(FeeRateException value, Uint8List buf) {
    return value.write(buf);
  }
}

class ArithmeticOverflowFeeRateException extends FeeRateException {
  ArithmeticOverflowFeeRateException();
  ArithmeticOverflowFeeRateException._();
  static LiftRetVal<ArithmeticOverflowFeeRateException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(ArithmeticOverflowFeeRateException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "ArithmeticOverflowFeeRateException";
  }
}

class FeeRateExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterFeeRateException.lift(errorBuf);
  }
}

final FeeRateExceptionErrorHandler feeRateExceptionErrorHandler =
    FeeRateExceptionErrorHandler();

abstract class FromScriptException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterFromScriptException {
  static FromScriptException lift(RustBuffer buffer) {
    return FfiConverterFromScriptException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<FromScriptException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return UnrecognizedScriptFromScriptException.read(subview);
      case 2:
        return WitnessProgramFromScriptException.read(subview);
      case 3:
        return WitnessVersionFromScriptException.read(subview);
      case 4:
        return OtherFromScriptErrFromScriptException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(FromScriptException value) {
    return value.lower();
  }

  static int allocationSize(FromScriptException value) {
    return value.allocationSize();
  }

  static int write(FromScriptException value, Uint8List buf) {
    return value.write(buf);
  }
}

class UnrecognizedScriptFromScriptException extends FromScriptException {
  UnrecognizedScriptFromScriptException();
  UnrecognizedScriptFromScriptException._();
  static LiftRetVal<UnrecognizedScriptFromScriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(UnrecognizedScriptFromScriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "UnrecognizedScriptFromScriptException";
  }
}

class WitnessProgramFromScriptException extends FromScriptException {
  final String errorMessage;
  WitnessProgramFromScriptException(String this.errorMessage);
  WitnessProgramFromScriptException._(String this.errorMessage);
  static LiftRetVal<WitnessProgramFromScriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      WitnessProgramFromScriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "WitnessProgramFromScriptException($errorMessage)";
  }
}

class WitnessVersionFromScriptException extends FromScriptException {
  final String errorMessage;
  WitnessVersionFromScriptException(String this.errorMessage);
  WitnessVersionFromScriptException._(String this.errorMessage);
  static LiftRetVal<WitnessVersionFromScriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      WitnessVersionFromScriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "WitnessVersionFromScriptException($errorMessage)";
  }
}

class OtherFromScriptErrFromScriptException extends FromScriptException {
  OtherFromScriptErrFromScriptException();
  OtherFromScriptErrFromScriptException._();
  static LiftRetVal<OtherFromScriptErrFromScriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(OtherFromScriptErrFromScriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "OtherFromScriptErrFromScriptException";
  }
}

class FromScriptExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterFromScriptException.lift(errorBuf);
  }
}

final FromScriptExceptionErrorHandler fromScriptExceptionErrorHandler =
    FromScriptExceptionErrorHandler();

abstract class HashParseException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterHashParseException {
  static HashParseException lift(RustBuffer buffer) {
    return FfiConverterHashParseException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<HashParseException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return InvalidHashHashParseException.read(subview);
      case 2:
        return InvalidHexStringHashParseException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(HashParseException value) {
    return value.lower();
  }

  static int allocationSize(HashParseException value) {
    return value.allocationSize();
  }

  static int write(HashParseException value, Uint8List buf) {
    return value.write(buf);
  }
}

class InvalidHashHashParseException extends HashParseException {
  final int len;
  InvalidHashHashParseException(int this.len);
  InvalidHashHashParseException._(int this.len);
  static LiftRetVal<InvalidHashHashParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final len_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final len = len_lifted.value;
    new_offset += len_lifted.bytesRead;
    return LiftRetVal(InvalidHashHashParseException._(len), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(len) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      len,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidHashHashParseException($len)";
  }
}

class InvalidHexStringHashParseException extends HashParseException {
  final String hex;
  InvalidHexStringHashParseException(String this.hex);
  InvalidHexStringHashParseException._(String this.hex);
  static LiftRetVal<InvalidHexStringHashParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final hex_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hex = hex_lifted.value;
    new_offset += hex_lifted.bytesRead;
    return LiftRetVal(InvalidHexStringHashParseException._(hex), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(hex) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      hex,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidHexStringHashParseException($hex)";
  }
}

class HashParseExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterHashParseException.lift(errorBuf);
  }
}

final HashParseExceptionErrorHandler hashParseExceptionErrorHandler =
    HashParseExceptionErrorHandler();

abstract class Info {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterInfo {
  static Info lift(RustBuffer buffer) {
    return FfiConverterInfo.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<Info> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return ConnectionsMetInfo.read(subview);
      case 2:
        return SuccessfulHandshakeInfo.read(subview);
      case 3:
        return ProgressInfo.read(subview);
      case 4:
        return BlockReceivedInfo.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(Info value) {
    return value.lower();
  }

  static int allocationSize(Info value) {
    return value.allocationSize();
  }

  static int write(Info value, Uint8List buf) {
    return value.write(buf);
  }
}

class ConnectionsMetInfo extends Info {
  ConnectionsMetInfo();
  ConnectionsMetInfo._();
  static LiftRetVal<ConnectionsMetInfo> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(ConnectionsMetInfo._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class SuccessfulHandshakeInfo extends Info {
  SuccessfulHandshakeInfo();
  SuccessfulHandshakeInfo._();
  static LiftRetVal<SuccessfulHandshakeInfo> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(SuccessfulHandshakeInfo._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class ProgressInfo extends Info {
  final int chainHeight;
  final double filtersDownloadedPercent;
  ProgressInfo({
    required int this.chainHeight,
    required double this.filtersDownloadedPercent,
  });
  ProgressInfo._(int this.chainHeight, double this.filtersDownloadedPercent);
  static LiftRetVal<ProgressInfo> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final chainHeight_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final chainHeight = chainHeight_lifted.value;
    new_offset += chainHeight_lifted.bytesRead;
    final filtersDownloadedPercent_lifted = FfiConverterDouble32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final filtersDownloadedPercent = filtersDownloadedPercent_lifted.value;
    new_offset += filtersDownloadedPercent_lifted.bytesRead;
    return LiftRetVal(
      ProgressInfo._(chainHeight, filtersDownloadedPercent),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(chainHeight) +
        FfiConverterDouble32.allocationSize(filtersDownloadedPercent) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      chainHeight,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterDouble32.write(
      filtersDownloadedPercent,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class BlockReceivedInfo extends Info {
  final String v0;
  BlockReceivedInfo(String this.v0);
  BlockReceivedInfo._(String this.v0);
  static LiftRetVal<BlockReceivedInfo> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final v0_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final v0 = v0_lifted.value;
    new_offset += v0_lifted.bytesRead;
    return LiftRetVal(BlockReceivedInfo._(v0), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(v0) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      v0,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

enum KeychainKind { external_, internal }

class FfiConverterKeychainKind {
  static LiftRetVal<KeychainKind> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(KeychainKind.external_, 4);
      case 2:
        return LiftRetVal(KeychainKind.internal, 4);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static KeychainKind lift(RustBuffer buffer) {
    return FfiConverterKeychainKind.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(KeychainKind input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(KeychainKind _value) {
    return 4;
  }

  static int write(KeychainKind value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

abstract class LoadWithPersistException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterLoadWithPersistException {
  static LoadWithPersistException lift(RustBuffer buffer) {
    return FfiConverterLoadWithPersistException.read(
      buffer.asUint8List(),
    ).value;
  }

  static LiftRetVal<LoadWithPersistException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return PersistLoadWithPersistException.read(subview);
      case 2:
        return InvalidChangeSetLoadWithPersistException.read(subview);
      case 3:
        return CouldNotLoadLoadWithPersistException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(LoadWithPersistException value) {
    return value.lower();
  }

  static int allocationSize(LoadWithPersistException value) {
    return value.allocationSize();
  }

  static int write(LoadWithPersistException value, Uint8List buf) {
    return value.write(buf);
  }
}

class PersistLoadWithPersistException extends LoadWithPersistException {
  final String errorMessage;
  PersistLoadWithPersistException(String this.errorMessage);
  PersistLoadWithPersistException._(String this.errorMessage);
  static LiftRetVal<PersistLoadWithPersistException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      PersistLoadWithPersistException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PersistLoadWithPersistException($errorMessage)";
  }
}

class InvalidChangeSetLoadWithPersistException
    extends LoadWithPersistException {
  final String errorMessage;
  InvalidChangeSetLoadWithPersistException(String this.errorMessage);
  InvalidChangeSetLoadWithPersistException._(String this.errorMessage);
  static LiftRetVal<InvalidChangeSetLoadWithPersistException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      InvalidChangeSetLoadWithPersistException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidChangeSetLoadWithPersistException($errorMessage)";
  }
}

class CouldNotLoadLoadWithPersistException extends LoadWithPersistException {
  CouldNotLoadLoadWithPersistException();
  CouldNotLoadLoadWithPersistException._();
  static LiftRetVal<CouldNotLoadLoadWithPersistException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(CouldNotLoadLoadWithPersistException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "CouldNotLoadLoadWithPersistException";
  }
}

class LoadWithPersistExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterLoadWithPersistException.lift(errorBuf);
  }
}

final LoadWithPersistExceptionErrorHandler
loadWithPersistExceptionErrorHandler = LoadWithPersistExceptionErrorHandler();

abstract class LockTime {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterLockTime {
  static LockTime lift(RustBuffer buffer) {
    return FfiConverterLockTime.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<LockTime> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return BlocksLockTime.read(subview);
      case 2:
        return SecondsLockTime.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(LockTime value) {
    return value.lower();
  }

  static int allocationSize(LockTime value) {
    return value.allocationSize();
  }

  static int write(LockTime value, Uint8List buf) {
    return value.write(buf);
  }
}

class BlocksLockTime extends LockTime {
  final int height;
  BlocksLockTime(int this.height);
  BlocksLockTime._(int this.height);
  static LiftRetVal<BlocksLockTime> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final height_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final height = height_lifted.value;
    new_offset += height_lifted.bytesRead;
    return LiftRetVal(BlocksLockTime._(height), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(height) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      height,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class SecondsLockTime extends LockTime {
  final int consensusTime;
  SecondsLockTime(int this.consensusTime);
  SecondsLockTime._(int this.consensusTime);
  static LiftRetVal<SecondsLockTime> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final consensusTime_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final consensusTime = consensusTime_lifted.value;
    new_offset += consensusTime_lifted.bytesRead;
    return LiftRetVal(SecondsLockTime._(consensusTime), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(consensusTime) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      consensusTime,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

abstract class MiniscriptException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterMiniscriptException {
  static MiniscriptException lift(RustBuffer buffer) {
    return FfiConverterMiniscriptException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<MiniscriptException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return AbsoluteLockTimeMiniscriptException.read(subview);
      case 2:
        return AddrExceptionMiniscriptException.read(subview);
      case 3:
        return AddrP2shExceptionMiniscriptException.read(subview);
      case 4:
        return AnalysisExceptionMiniscriptException.read(subview);
      case 5:
        return AtOutsideOrMiniscriptException.read(subview);
      case 6:
        return BadDescriptorMiniscriptException.read(subview);
      case 7:
        return BareDescriptorAddrMiniscriptException.read(subview);
      case 8:
        return CmsTooManyKeysMiniscriptException.read(subview);
      case 9:
        return ContextExceptionMiniscriptException.read(subview);
      case 10:
        return CouldNotSatisfyMiniscriptException.read(subview);
      case 11:
        return ExpectedCharMiniscriptException.read(subview);
      case 12:
        return ImpossibleSatisfactionMiniscriptException.read(subview);
      case 13:
        return InvalidOpcodeMiniscriptException.read(subview);
      case 14:
        return InvalidPushMiniscriptException.read(subview);
      case 15:
        return LiftExceptionMiniscriptException.read(subview);
      case 16:
        return MaxRecursiveDepthExceededMiniscriptException.read(subview);
      case 17:
        return MissingSigMiniscriptException.read(subview);
      case 18:
        return MultiATooManyKeysMiniscriptException.read(subview);
      case 19:
        return MultiColonMiniscriptException.read(subview);
      case 20:
        return MultipathDescLenMismatchMiniscriptException.read(subview);
      case 21:
        return NonMinimalVerifyMiniscriptException.read(subview);
      case 22:
        return NonStandardBareScriptMiniscriptException.read(subview);
      case 23:
        return NonTopLevelMiniscriptException.read(subview);
      case 24:
        return ParseThresholdMiniscriptException.read(subview);
      case 25:
        return PolicyExceptionMiniscriptException.read(subview);
      case 26:
        return PubKeyCtxExceptionMiniscriptException.read(subview);
      case 27:
        return RelativeLockTimeMiniscriptException.read(subview);
      case 28:
        return ScriptMiniscriptException.read(subview);
      case 29:
        return SecpMiniscriptException.read(subview);
      case 30:
        return ThresholdMiniscriptException.read(subview);
      case 31:
        return TrNoScriptCodeMiniscriptException.read(subview);
      case 32:
        return TrailingMiniscriptException.read(subview);
      case 33:
        return TypeCheckMiniscriptException.read(subview);
      case 34:
        return UnexpectedMiniscriptException.read(subview);
      case 35:
        return UnexpectedStartMiniscriptException.read(subview);
      case 36:
        return UnknownWrapperMiniscriptException.read(subview);
      case 37:
        return UnprintableMiniscriptException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(MiniscriptException value) {
    return value.lower();
  }

  static int allocationSize(MiniscriptException value) {
    return value.allocationSize();
  }

  static int write(MiniscriptException value, Uint8List buf) {
    return value.write(buf);
  }
}

class AbsoluteLockTimeMiniscriptException extends MiniscriptException {
  AbsoluteLockTimeMiniscriptException();
  AbsoluteLockTimeMiniscriptException._();
  static LiftRetVal<AbsoluteLockTimeMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(AbsoluteLockTimeMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "AbsoluteLockTimeMiniscriptException";
  }
}

class AddrExceptionMiniscriptException extends MiniscriptException {
  final String errorMessage;
  AddrExceptionMiniscriptException(String this.errorMessage);
  AddrExceptionMiniscriptException._(String this.errorMessage);
  static LiftRetVal<AddrExceptionMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      AddrExceptionMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "AddrExceptionMiniscriptException($errorMessage)";
  }
}

class AddrP2shExceptionMiniscriptException extends MiniscriptException {
  final String errorMessage;
  AddrP2shExceptionMiniscriptException(String this.errorMessage);
  AddrP2shExceptionMiniscriptException._(String this.errorMessage);
  static LiftRetVal<AddrP2shExceptionMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      AddrP2shExceptionMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "AddrP2shExceptionMiniscriptException($errorMessage)";
  }
}

class AnalysisExceptionMiniscriptException extends MiniscriptException {
  final String errorMessage;
  AnalysisExceptionMiniscriptException(String this.errorMessage);
  AnalysisExceptionMiniscriptException._(String this.errorMessage);
  static LiftRetVal<AnalysisExceptionMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      AnalysisExceptionMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "AnalysisExceptionMiniscriptException($errorMessage)";
  }
}

class AtOutsideOrMiniscriptException extends MiniscriptException {
  AtOutsideOrMiniscriptException();
  AtOutsideOrMiniscriptException._();
  static LiftRetVal<AtOutsideOrMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(AtOutsideOrMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "AtOutsideOrMiniscriptException";
  }
}

class BadDescriptorMiniscriptException extends MiniscriptException {
  final String errorMessage;
  BadDescriptorMiniscriptException(String this.errorMessage);
  BadDescriptorMiniscriptException._(String this.errorMessage);
  static LiftRetVal<BadDescriptorMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      BadDescriptorMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "BadDescriptorMiniscriptException($errorMessage)";
  }
}

class BareDescriptorAddrMiniscriptException extends MiniscriptException {
  BareDescriptorAddrMiniscriptException();
  BareDescriptorAddrMiniscriptException._();
  static LiftRetVal<BareDescriptorAddrMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(BareDescriptorAddrMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "BareDescriptorAddrMiniscriptException";
  }
}

class CmsTooManyKeysMiniscriptException extends MiniscriptException {
  final int keys;
  CmsTooManyKeysMiniscriptException(int this.keys);
  CmsTooManyKeysMiniscriptException._(int this.keys);
  static LiftRetVal<CmsTooManyKeysMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final keys_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final keys = keys_lifted.value;
    new_offset += keys_lifted.bytesRead;
    return LiftRetVal(CmsTooManyKeysMiniscriptException._(keys), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(keys) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      keys,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "CmsTooManyKeysMiniscriptException($keys)";
  }
}

class ContextExceptionMiniscriptException extends MiniscriptException {
  final String errorMessage;
  ContextExceptionMiniscriptException(String this.errorMessage);
  ContextExceptionMiniscriptException._(String this.errorMessage);
  static LiftRetVal<ContextExceptionMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      ContextExceptionMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ContextExceptionMiniscriptException($errorMessage)";
  }
}

class CouldNotSatisfyMiniscriptException extends MiniscriptException {
  CouldNotSatisfyMiniscriptException();
  CouldNotSatisfyMiniscriptException._();
  static LiftRetVal<CouldNotSatisfyMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(CouldNotSatisfyMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "CouldNotSatisfyMiniscriptException";
  }
}

class ExpectedCharMiniscriptException extends MiniscriptException {
  final String char;
  ExpectedCharMiniscriptException(String this.char);
  ExpectedCharMiniscriptException._(String this.char);
  static LiftRetVal<ExpectedCharMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final char_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final char = char_lifted.value;
    new_offset += char_lifted.bytesRead;
    return LiftRetVal(ExpectedCharMiniscriptException._(char), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(char) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 11);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      char,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ExpectedCharMiniscriptException($char)";
  }
}

class ImpossibleSatisfactionMiniscriptException extends MiniscriptException {
  ImpossibleSatisfactionMiniscriptException();
  ImpossibleSatisfactionMiniscriptException._();
  static LiftRetVal<ImpossibleSatisfactionMiniscriptException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      ImpossibleSatisfactionMiniscriptException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 12);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "ImpossibleSatisfactionMiniscriptException";
  }
}

class InvalidOpcodeMiniscriptException extends MiniscriptException {
  InvalidOpcodeMiniscriptException();
  InvalidOpcodeMiniscriptException._();
  static LiftRetVal<InvalidOpcodeMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidOpcodeMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 13);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidOpcodeMiniscriptException";
  }
}

class InvalidPushMiniscriptException extends MiniscriptException {
  InvalidPushMiniscriptException();
  InvalidPushMiniscriptException._();
  static LiftRetVal<InvalidPushMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidPushMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 14);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidPushMiniscriptException";
  }
}

class LiftExceptionMiniscriptException extends MiniscriptException {
  final String errorMessage;
  LiftExceptionMiniscriptException(String this.errorMessage);
  LiftExceptionMiniscriptException._(String this.errorMessage);
  static LiftRetVal<LiftExceptionMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      LiftExceptionMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 15);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "LiftExceptionMiniscriptException($errorMessage)";
  }
}

class MaxRecursiveDepthExceededMiniscriptException extends MiniscriptException {
  MaxRecursiveDepthExceededMiniscriptException();
  MaxRecursiveDepthExceededMiniscriptException._();
  static LiftRetVal<MaxRecursiveDepthExceededMiniscriptException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      MaxRecursiveDepthExceededMiniscriptException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 16);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MaxRecursiveDepthExceededMiniscriptException";
  }
}

class MissingSigMiniscriptException extends MiniscriptException {
  MissingSigMiniscriptException();
  MissingSigMiniscriptException._();
  static LiftRetVal<MissingSigMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingSigMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 17);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingSigMiniscriptException";
  }
}

class MultiATooManyKeysMiniscriptException extends MiniscriptException {
  final int keys;
  MultiATooManyKeysMiniscriptException(int this.keys);
  MultiATooManyKeysMiniscriptException._(int this.keys);
  static LiftRetVal<MultiATooManyKeysMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final keys_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final keys = keys_lifted.value;
    new_offset += keys_lifted.bytesRead;
    return LiftRetVal(MultiATooManyKeysMiniscriptException._(keys), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(keys) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 18);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      keys,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MultiATooManyKeysMiniscriptException($keys)";
  }
}

class MultiColonMiniscriptException extends MiniscriptException {
  MultiColonMiniscriptException();
  MultiColonMiniscriptException._();
  static LiftRetVal<MultiColonMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MultiColonMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 19);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MultiColonMiniscriptException";
  }
}

class MultipathDescLenMismatchMiniscriptException extends MiniscriptException {
  MultipathDescLenMismatchMiniscriptException();
  MultipathDescLenMismatchMiniscriptException._();
  static LiftRetVal<MultipathDescLenMismatchMiniscriptException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      MultipathDescLenMismatchMiniscriptException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 20);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MultipathDescLenMismatchMiniscriptException";
  }
}

class NonMinimalVerifyMiniscriptException extends MiniscriptException {
  final String errorMessage;
  NonMinimalVerifyMiniscriptException(String this.errorMessage);
  NonMinimalVerifyMiniscriptException._(String this.errorMessage);
  static LiftRetVal<NonMinimalVerifyMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      NonMinimalVerifyMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 21);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "NonMinimalVerifyMiniscriptException($errorMessage)";
  }
}

class NonStandardBareScriptMiniscriptException extends MiniscriptException {
  NonStandardBareScriptMiniscriptException();
  NonStandardBareScriptMiniscriptException._();
  static LiftRetVal<NonStandardBareScriptMiniscriptException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NonStandardBareScriptMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 22);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NonStandardBareScriptMiniscriptException";
  }
}

class NonTopLevelMiniscriptException extends MiniscriptException {
  final String errorMessage;
  NonTopLevelMiniscriptException(String this.errorMessage);
  NonTopLevelMiniscriptException._(String this.errorMessage);
  static LiftRetVal<NonTopLevelMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      NonTopLevelMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 23);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "NonTopLevelMiniscriptException($errorMessage)";
  }
}

class ParseThresholdMiniscriptException extends MiniscriptException {
  ParseThresholdMiniscriptException();
  ParseThresholdMiniscriptException._();
  static LiftRetVal<ParseThresholdMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(ParseThresholdMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 24);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "ParseThresholdMiniscriptException";
  }
}

class PolicyExceptionMiniscriptException extends MiniscriptException {
  final String errorMessage;
  PolicyExceptionMiniscriptException(String this.errorMessage);
  PolicyExceptionMiniscriptException._(String this.errorMessage);
  static LiftRetVal<PolicyExceptionMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      PolicyExceptionMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 25);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PolicyExceptionMiniscriptException($errorMessage)";
  }
}

class PubKeyCtxExceptionMiniscriptException extends MiniscriptException {
  PubKeyCtxExceptionMiniscriptException();
  PubKeyCtxExceptionMiniscriptException._();
  static LiftRetVal<PubKeyCtxExceptionMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(PubKeyCtxExceptionMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 26);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "PubKeyCtxExceptionMiniscriptException";
  }
}

class RelativeLockTimeMiniscriptException extends MiniscriptException {
  RelativeLockTimeMiniscriptException();
  RelativeLockTimeMiniscriptException._();
  static LiftRetVal<RelativeLockTimeMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(RelativeLockTimeMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 27);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "RelativeLockTimeMiniscriptException";
  }
}

class ScriptMiniscriptException extends MiniscriptException {
  final String errorMessage;
  ScriptMiniscriptException(String this.errorMessage);
  ScriptMiniscriptException._(String this.errorMessage);
  static LiftRetVal<ScriptMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(ScriptMiniscriptException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 28);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ScriptMiniscriptException($errorMessage)";
  }
}

class SecpMiniscriptException extends MiniscriptException {
  final String errorMessage;
  SecpMiniscriptException(String this.errorMessage);
  SecpMiniscriptException._(String this.errorMessage);
  static LiftRetVal<SecpMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(SecpMiniscriptException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 29);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "SecpMiniscriptException($errorMessage)";
  }
}

class ThresholdMiniscriptException extends MiniscriptException {
  ThresholdMiniscriptException();
  ThresholdMiniscriptException._();
  static LiftRetVal<ThresholdMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(ThresholdMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 30);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "ThresholdMiniscriptException";
  }
}

class TrNoScriptCodeMiniscriptException extends MiniscriptException {
  TrNoScriptCodeMiniscriptException();
  TrNoScriptCodeMiniscriptException._();
  static LiftRetVal<TrNoScriptCodeMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(TrNoScriptCodeMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 31);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "TrNoScriptCodeMiniscriptException";
  }
}

class TrailingMiniscriptException extends MiniscriptException {
  final String errorMessage;
  TrailingMiniscriptException(String this.errorMessage);
  TrailingMiniscriptException._(String this.errorMessage);
  static LiftRetVal<TrailingMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(TrailingMiniscriptException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 32);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "TrailingMiniscriptException($errorMessage)";
  }
}

class TypeCheckMiniscriptException extends MiniscriptException {
  final String errorMessage;
  TypeCheckMiniscriptException(String this.errorMessage);
  TypeCheckMiniscriptException._(String this.errorMessage);
  static LiftRetVal<TypeCheckMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(TypeCheckMiniscriptException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 33);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "TypeCheckMiniscriptException($errorMessage)";
  }
}

class UnexpectedMiniscriptException extends MiniscriptException {
  final String errorMessage;
  UnexpectedMiniscriptException(String this.errorMessage);
  UnexpectedMiniscriptException._(String this.errorMessage);
  static LiftRetVal<UnexpectedMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      UnexpectedMiniscriptException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 34);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "UnexpectedMiniscriptException($errorMessage)";
  }
}

class UnexpectedStartMiniscriptException extends MiniscriptException {
  UnexpectedStartMiniscriptException();
  UnexpectedStartMiniscriptException._();
  static LiftRetVal<UnexpectedStartMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(UnexpectedStartMiniscriptException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 35);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "UnexpectedStartMiniscriptException";
  }
}

class UnknownWrapperMiniscriptException extends MiniscriptException {
  final String char;
  UnknownWrapperMiniscriptException(String this.char);
  UnknownWrapperMiniscriptException._(String this.char);
  static LiftRetVal<UnknownWrapperMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final char_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final char = char_lifted.value;
    new_offset += char_lifted.bytesRead;
    return LiftRetVal(UnknownWrapperMiniscriptException._(char), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(char) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 36);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      char,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "UnknownWrapperMiniscriptException($char)";
  }
}

class UnprintableMiniscriptException extends MiniscriptException {
  final int byte;
  UnprintableMiniscriptException(int this.byte);
  UnprintableMiniscriptException._(int this.byte);
  static LiftRetVal<UnprintableMiniscriptException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final byte_lifted = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final byte = byte_lifted.value;
    new_offset += byte_lifted.bytesRead;
    return LiftRetVal(UnprintableMiniscriptException._(byte), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt8.allocationSize(byte) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 37);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt8.write(
      byte,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "UnprintableMiniscriptException($byte)";
  }
}

class MiniscriptExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterMiniscriptException.lift(errorBuf);
  }
}

final MiniscriptExceptionErrorHandler miniscriptExceptionErrorHandler =
    MiniscriptExceptionErrorHandler();

enum Network { bitcoin, testnet, testnet4, signet, regtest }

class FfiConverterNetwork {
  static LiftRetVal<Network> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(Network.bitcoin, 4);
      case 2:
        return LiftRetVal(Network.testnet, 4);
      case 3:
        return LiftRetVal(Network.testnet4, 4);
      case 4:
        return LiftRetVal(Network.signet, 4);
      case 5:
        return LiftRetVal(Network.regtest, 4);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static Network lift(RustBuffer buffer) {
    return FfiConverterNetwork.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(Network input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(Network _value) {
    return 4;
  }

  static int write(Network value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

abstract class ParseAmountException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterParseAmountException {
  static ParseAmountException lift(RustBuffer buffer) {
    return FfiConverterParseAmountException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<ParseAmountException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return OutOfRangeParseAmountException.read(subview);
      case 2:
        return TooPreciseParseAmountException.read(subview);
      case 3:
        return MissingDigitsParseAmountException.read(subview);
      case 4:
        return InputTooLargeParseAmountException.read(subview);
      case 5:
        return InvalidCharacterParseAmountException.read(subview);
      case 6:
        return OtherParseAmountErrParseAmountException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(ParseAmountException value) {
    return value.lower();
  }

  static int allocationSize(ParseAmountException value) {
    return value.allocationSize();
  }

  static int write(ParseAmountException value, Uint8List buf) {
    return value.write(buf);
  }
}

class OutOfRangeParseAmountException extends ParseAmountException {
  OutOfRangeParseAmountException();
  OutOfRangeParseAmountException._();
  static LiftRetVal<OutOfRangeParseAmountException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(OutOfRangeParseAmountException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "OutOfRangeParseAmountException";
  }
}

class TooPreciseParseAmountException extends ParseAmountException {
  TooPreciseParseAmountException();
  TooPreciseParseAmountException._();
  static LiftRetVal<TooPreciseParseAmountException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(TooPreciseParseAmountException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "TooPreciseParseAmountException";
  }
}

class MissingDigitsParseAmountException extends ParseAmountException {
  MissingDigitsParseAmountException();
  MissingDigitsParseAmountException._();
  static LiftRetVal<MissingDigitsParseAmountException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingDigitsParseAmountException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingDigitsParseAmountException";
  }
}

class InputTooLargeParseAmountException extends ParseAmountException {
  InputTooLargeParseAmountException();
  InputTooLargeParseAmountException._();
  static LiftRetVal<InputTooLargeParseAmountException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InputTooLargeParseAmountException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InputTooLargeParseAmountException";
  }
}

class InvalidCharacterParseAmountException extends ParseAmountException {
  final String errorMessage;
  InvalidCharacterParseAmountException(String this.errorMessage);
  InvalidCharacterParseAmountException._(String this.errorMessage);
  static LiftRetVal<InvalidCharacterParseAmountException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      InvalidCharacterParseAmountException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidCharacterParseAmountException($errorMessage)";
  }
}

class OtherParseAmountErrParseAmountException extends ParseAmountException {
  OtherParseAmountErrParseAmountException();
  OtherParseAmountErrParseAmountException._();
  static LiftRetVal<OtherParseAmountErrParseAmountException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(OtherParseAmountErrParseAmountException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "OtherParseAmountErrParseAmountException";
  }
}

class ParseAmountExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterParseAmountException.lift(errorBuf);
  }
}

final ParseAmountExceptionErrorHandler parseAmountExceptionErrorHandler =
    ParseAmountExceptionErrorHandler();

abstract class PersistenceException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterPersistenceException {
  static PersistenceException lift(RustBuffer buffer) {
    return FfiConverterPersistenceException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<PersistenceException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return ReasonPersistenceException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(PersistenceException value) {
    return value.lower();
  }

  static int allocationSize(PersistenceException value) {
    return value.allocationSize();
  }

  static int write(PersistenceException value, Uint8List buf) {
    return value.write(buf);
  }
}

class ReasonPersistenceException extends PersistenceException {
  final String errorMessage;
  ReasonPersistenceException(String this.errorMessage);
  ReasonPersistenceException._(String this.errorMessage);
  static LiftRetVal<ReasonPersistenceException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(ReasonPersistenceException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ReasonPersistenceException($errorMessage)";
  }
}

class PersistenceExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterPersistenceException.lift(errorBuf);
  }
}

final PersistenceExceptionErrorHandler persistenceExceptionErrorHandler =
    PersistenceExceptionErrorHandler();

abstract class PkOrF {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterPkOrF {
  static PkOrF lift(RustBuffer buffer) {
    return FfiConverterPkOrF.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<PkOrF> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return PubkeyPkOrF.read(subview);
      case 2:
        return XOnlyPubkeyPkOrF.read(subview);
      case 3:
        return FingerprintPkOrF.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(PkOrF value) {
    return value.lower();
  }

  static int allocationSize(PkOrF value) {
    return value.allocationSize();
  }

  static int write(PkOrF value, Uint8List buf) {
    return value.write(buf);
  }
}

class PubkeyPkOrF extends PkOrF {
  final String value;
  PubkeyPkOrF(String this.value);
  PubkeyPkOrF._(String this.value);
  static LiftRetVal<PubkeyPkOrF> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final value_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final value = value_lifted.value;
    new_offset += value_lifted.bytesRead;
    return LiftRetVal(PubkeyPkOrF._(value), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(value) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      value,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class XOnlyPubkeyPkOrF extends PkOrF {
  final String value;
  XOnlyPubkeyPkOrF(String this.value);
  XOnlyPubkeyPkOrF._(String this.value);
  static LiftRetVal<XOnlyPubkeyPkOrF> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final value_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final value = value_lifted.value;
    new_offset += value_lifted.bytesRead;
    return LiftRetVal(XOnlyPubkeyPkOrF._(value), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(value) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      value,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class FingerprintPkOrF extends PkOrF {
  final String value;
  FingerprintPkOrF(String this.value);
  FingerprintPkOrF._(String this.value);
  static LiftRetVal<FingerprintPkOrF> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final value_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final value = value_lifted.value;
    new_offset += value_lifted.bytesRead;
    return LiftRetVal(FingerprintPkOrF._(value), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(value) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      value,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

abstract class PsbtException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterPsbtException {
  static PsbtException lift(RustBuffer buffer) {
    return FfiConverterPsbtException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<PsbtException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return InvalidMagicPsbtException.read(subview);
      case 2:
        return MissingUtxoPsbtException.read(subview);
      case 3:
        return InvalidSeparatorPsbtException.read(subview);
      case 4:
        return PsbtUtxoOutOfBoundsPsbtException.read(subview);
      case 5:
        return InvalidKeyPsbtException.read(subview);
      case 6:
        return InvalidProprietaryKeyPsbtException.read(subview);
      case 7:
        return DuplicateKeyPsbtException.read(subview);
      case 8:
        return UnsignedTxHasScriptSigsPsbtException.read(subview);
      case 9:
        return UnsignedTxHasScriptWitnessesPsbtException.read(subview);
      case 10:
        return MustHaveUnsignedTxPsbtException.read(subview);
      case 11:
        return NoMorePairsPsbtException.read(subview);
      case 12:
        return UnexpectedUnsignedTxPsbtException.read(subview);
      case 13:
        return NonStandardSighashTypePsbtException.read(subview);
      case 14:
        return InvalidHashPsbtException.read(subview);
      case 15:
        return InvalidPreimageHashPairPsbtException.read(subview);
      case 16:
        return CombineInconsistentKeySourcesPsbtException.read(subview);
      case 17:
        return ConsensusEncodingPsbtException.read(subview);
      case 18:
        return NegativeFeePsbtException.read(subview);
      case 19:
        return FeeOverflowPsbtException.read(subview);
      case 20:
        return InvalidPublicKeyPsbtException.read(subview);
      case 21:
        return InvalidSecp256k1PublicKeyPsbtException.read(subview);
      case 22:
        return InvalidXOnlyPublicKeyPsbtException.read(subview);
      case 23:
        return InvalidEcdsaSignaturePsbtException.read(subview);
      case 24:
        return InvalidTaprootSignaturePsbtException.read(subview);
      case 25:
        return InvalidControlBlockPsbtException.read(subview);
      case 26:
        return InvalidLeafVersionPsbtException.read(subview);
      case 27:
        return TaprootPsbtException.read(subview);
      case 28:
        return TapTreePsbtException.read(subview);
      case 29:
        return XPubKeyPsbtException.read(subview);
      case 30:
        return VersionPsbtException.read(subview);
      case 31:
        return PartialDataConsumptionPsbtException.read(subview);
      case 32:
        return IoPsbtException.read(subview);
      case 33:
        return OtherPsbtErrPsbtException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(PsbtException value) {
    return value.lower();
  }

  static int allocationSize(PsbtException value) {
    return value.allocationSize();
  }

  static int write(PsbtException value, Uint8List buf) {
    return value.write(buf);
  }
}

class InvalidMagicPsbtException extends PsbtException {
  InvalidMagicPsbtException();
  InvalidMagicPsbtException._();
  static LiftRetVal<InvalidMagicPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidMagicPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidMagicPsbtException";
  }
}

class MissingUtxoPsbtException extends PsbtException {
  MissingUtxoPsbtException();
  MissingUtxoPsbtException._();
  static LiftRetVal<MissingUtxoPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingUtxoPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingUtxoPsbtException";
  }
}

class InvalidSeparatorPsbtException extends PsbtException {
  InvalidSeparatorPsbtException();
  InvalidSeparatorPsbtException._();
  static LiftRetVal<InvalidSeparatorPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidSeparatorPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidSeparatorPsbtException";
  }
}

class PsbtUtxoOutOfBoundsPsbtException extends PsbtException {
  PsbtUtxoOutOfBoundsPsbtException();
  PsbtUtxoOutOfBoundsPsbtException._();
  static LiftRetVal<PsbtUtxoOutOfBoundsPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(PsbtUtxoOutOfBoundsPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "PsbtUtxoOutOfBoundsPsbtException";
  }
}

class InvalidKeyPsbtException extends PsbtException {
  final String key;
  InvalidKeyPsbtException(String this.key);
  InvalidKeyPsbtException._(String this.key);
  static LiftRetVal<InvalidKeyPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final key_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final key = key_lifted.value;
    new_offset += key_lifted.bytesRead;
    return LiftRetVal(InvalidKeyPsbtException._(key), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(key) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      key,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidKeyPsbtException($key)";
  }
}

class InvalidProprietaryKeyPsbtException extends PsbtException {
  InvalidProprietaryKeyPsbtException();
  InvalidProprietaryKeyPsbtException._();
  static LiftRetVal<InvalidProprietaryKeyPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidProprietaryKeyPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidProprietaryKeyPsbtException";
  }
}

class DuplicateKeyPsbtException extends PsbtException {
  final String key;
  DuplicateKeyPsbtException(String this.key);
  DuplicateKeyPsbtException._(String this.key);
  static LiftRetVal<DuplicateKeyPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final key_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final key = key_lifted.value;
    new_offset += key_lifted.bytesRead;
    return LiftRetVal(DuplicateKeyPsbtException._(key), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(key) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      key,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "DuplicateKeyPsbtException($key)";
  }
}

class UnsignedTxHasScriptSigsPsbtException extends PsbtException {
  UnsignedTxHasScriptSigsPsbtException();
  UnsignedTxHasScriptSigsPsbtException._();
  static LiftRetVal<UnsignedTxHasScriptSigsPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(UnsignedTxHasScriptSigsPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "UnsignedTxHasScriptSigsPsbtException";
  }
}

class UnsignedTxHasScriptWitnessesPsbtException extends PsbtException {
  UnsignedTxHasScriptWitnessesPsbtException();
  UnsignedTxHasScriptWitnessesPsbtException._();
  static LiftRetVal<UnsignedTxHasScriptWitnessesPsbtException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      UnsignedTxHasScriptWitnessesPsbtException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "UnsignedTxHasScriptWitnessesPsbtException";
  }
}

class MustHaveUnsignedTxPsbtException extends PsbtException {
  MustHaveUnsignedTxPsbtException();
  MustHaveUnsignedTxPsbtException._();
  static LiftRetVal<MustHaveUnsignedTxPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MustHaveUnsignedTxPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MustHaveUnsignedTxPsbtException";
  }
}

class NoMorePairsPsbtException extends PsbtException {
  NoMorePairsPsbtException();
  NoMorePairsPsbtException._();
  static LiftRetVal<NoMorePairsPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NoMorePairsPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 11);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NoMorePairsPsbtException";
  }
}

class UnexpectedUnsignedTxPsbtException extends PsbtException {
  UnexpectedUnsignedTxPsbtException();
  UnexpectedUnsignedTxPsbtException._();
  static LiftRetVal<UnexpectedUnsignedTxPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(UnexpectedUnsignedTxPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 12);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "UnexpectedUnsignedTxPsbtException";
  }
}

class NonStandardSighashTypePsbtException extends PsbtException {
  final int sighash;
  NonStandardSighashTypePsbtException(int this.sighash);
  NonStandardSighashTypePsbtException._(int this.sighash);
  static LiftRetVal<NonStandardSighashTypePsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sighash_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final sighash = sighash_lifted.value;
    new_offset += sighash_lifted.bytesRead;
    return LiftRetVal(
      NonStandardSighashTypePsbtException._(sighash),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(sighash) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 13);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      sighash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "NonStandardSighashTypePsbtException($sighash)";
  }
}

class InvalidHashPsbtException extends PsbtException {
  final String hash;
  InvalidHashPsbtException(String this.hash);
  InvalidHashPsbtException._(String this.hash);
  static LiftRetVal<InvalidHashPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final hash_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hash = hash_lifted.value;
    new_offset += hash_lifted.bytesRead;
    return LiftRetVal(InvalidHashPsbtException._(hash), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(hash) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 14);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      hash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidHashPsbtException($hash)";
  }
}

class InvalidPreimageHashPairPsbtException extends PsbtException {
  InvalidPreimageHashPairPsbtException();
  InvalidPreimageHashPairPsbtException._();
  static LiftRetVal<InvalidPreimageHashPairPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidPreimageHashPairPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 15);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidPreimageHashPairPsbtException";
  }
}

class CombineInconsistentKeySourcesPsbtException extends PsbtException {
  final String xpub;
  CombineInconsistentKeySourcesPsbtException(String this.xpub);
  CombineInconsistentKeySourcesPsbtException._(String this.xpub);
  static LiftRetVal<CombineInconsistentKeySourcesPsbtException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final xpub_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final xpub = xpub_lifted.value;
    new_offset += xpub_lifted.bytesRead;
    return LiftRetVal(
      CombineInconsistentKeySourcesPsbtException._(xpub),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(xpub) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 16);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      xpub,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "CombineInconsistentKeySourcesPsbtException($xpub)";
  }
}

class ConsensusEncodingPsbtException extends PsbtException {
  final String encodingError;
  ConsensusEncodingPsbtException(String this.encodingError);
  ConsensusEncodingPsbtException._(String this.encodingError);
  static LiftRetVal<ConsensusEncodingPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final encodingError_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final encodingError = encodingError_lifted.value;
    new_offset += encodingError_lifted.bytesRead;
    return LiftRetVal(
      ConsensusEncodingPsbtException._(encodingError),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(encodingError) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 17);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      encodingError,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ConsensusEncodingPsbtException($encodingError)";
  }
}

class NegativeFeePsbtException extends PsbtException {
  NegativeFeePsbtException();
  NegativeFeePsbtException._();
  static LiftRetVal<NegativeFeePsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NegativeFeePsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 18);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NegativeFeePsbtException";
  }
}

class FeeOverflowPsbtException extends PsbtException {
  FeeOverflowPsbtException();
  FeeOverflowPsbtException._();
  static LiftRetVal<FeeOverflowPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(FeeOverflowPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 19);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "FeeOverflowPsbtException";
  }
}

class InvalidPublicKeyPsbtException extends PsbtException {
  final String errorMessage;
  InvalidPublicKeyPsbtException(String this.errorMessage);
  InvalidPublicKeyPsbtException._(String this.errorMessage);
  static LiftRetVal<InvalidPublicKeyPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      InvalidPublicKeyPsbtException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 20);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidPublicKeyPsbtException($errorMessage)";
  }
}

class InvalidSecp256k1PublicKeyPsbtException extends PsbtException {
  final String secp256k1Error;
  InvalidSecp256k1PublicKeyPsbtException(String this.secp256k1Error);
  InvalidSecp256k1PublicKeyPsbtException._(String this.secp256k1Error);
  static LiftRetVal<InvalidSecp256k1PublicKeyPsbtException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final secp256k1Error_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final secp256k1Error = secp256k1Error_lifted.value;
    new_offset += secp256k1Error_lifted.bytesRead;
    return LiftRetVal(
      InvalidSecp256k1PublicKeyPsbtException._(secp256k1Error),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(secp256k1Error) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 21);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      secp256k1Error,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidSecp256k1PublicKeyPsbtException($secp256k1Error)";
  }
}

class InvalidXOnlyPublicKeyPsbtException extends PsbtException {
  InvalidXOnlyPublicKeyPsbtException();
  InvalidXOnlyPublicKeyPsbtException._();
  static LiftRetVal<InvalidXOnlyPublicKeyPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidXOnlyPublicKeyPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 22);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidXOnlyPublicKeyPsbtException";
  }
}

class InvalidEcdsaSignaturePsbtException extends PsbtException {
  final String errorMessage;
  InvalidEcdsaSignaturePsbtException(String this.errorMessage);
  InvalidEcdsaSignaturePsbtException._(String this.errorMessage);
  static LiftRetVal<InvalidEcdsaSignaturePsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      InvalidEcdsaSignaturePsbtException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 23);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidEcdsaSignaturePsbtException($errorMessage)";
  }
}

class InvalidTaprootSignaturePsbtException extends PsbtException {
  final String errorMessage;
  InvalidTaprootSignaturePsbtException(String this.errorMessage);
  InvalidTaprootSignaturePsbtException._(String this.errorMessage);
  static LiftRetVal<InvalidTaprootSignaturePsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      InvalidTaprootSignaturePsbtException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 24);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidTaprootSignaturePsbtException($errorMessage)";
  }
}

class InvalidControlBlockPsbtException extends PsbtException {
  InvalidControlBlockPsbtException();
  InvalidControlBlockPsbtException._();
  static LiftRetVal<InvalidControlBlockPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidControlBlockPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 25);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidControlBlockPsbtException";
  }
}

class InvalidLeafVersionPsbtException extends PsbtException {
  InvalidLeafVersionPsbtException();
  InvalidLeafVersionPsbtException._();
  static LiftRetVal<InvalidLeafVersionPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidLeafVersionPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 26);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidLeafVersionPsbtException";
  }
}

class TaprootPsbtException extends PsbtException {
  TaprootPsbtException();
  TaprootPsbtException._();
  static LiftRetVal<TaprootPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(TaprootPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 27);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "TaprootPsbtException";
  }
}

class TapTreePsbtException extends PsbtException {
  final String errorMessage;
  TapTreePsbtException(String this.errorMessage);
  TapTreePsbtException._(String this.errorMessage);
  static LiftRetVal<TapTreePsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(TapTreePsbtException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 28);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "TapTreePsbtException($errorMessage)";
  }
}

class XPubKeyPsbtException extends PsbtException {
  XPubKeyPsbtException();
  XPubKeyPsbtException._();
  static LiftRetVal<XPubKeyPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(XPubKeyPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 29);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "XPubKeyPsbtException";
  }
}

class VersionPsbtException extends PsbtException {
  final String errorMessage;
  VersionPsbtException(String this.errorMessage);
  VersionPsbtException._(String this.errorMessage);
  static LiftRetVal<VersionPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(VersionPsbtException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 30);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "VersionPsbtException($errorMessage)";
  }
}

class PartialDataConsumptionPsbtException extends PsbtException {
  PartialDataConsumptionPsbtException();
  PartialDataConsumptionPsbtException._();
  static LiftRetVal<PartialDataConsumptionPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(PartialDataConsumptionPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 31);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "PartialDataConsumptionPsbtException";
  }
}

class IoPsbtException extends PsbtException {
  final String errorMessage;
  IoPsbtException(String this.errorMessage);
  IoPsbtException._(String this.errorMessage);
  static LiftRetVal<IoPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(IoPsbtException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 32);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "IoPsbtException($errorMessage)";
  }
}

class OtherPsbtErrPsbtException extends PsbtException {
  OtherPsbtErrPsbtException();
  OtherPsbtErrPsbtException._();
  static LiftRetVal<OtherPsbtErrPsbtException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(OtherPsbtErrPsbtException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 33);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "OtherPsbtErrPsbtException";
  }
}

class PsbtExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterPsbtException.lift(errorBuf);
  }
}

final PsbtExceptionErrorHandler psbtExceptionErrorHandler =
    PsbtExceptionErrorHandler();

abstract class PsbtFinalizeException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterPsbtFinalizeException {
  static PsbtFinalizeException lift(RustBuffer buffer) {
    return FfiConverterPsbtFinalizeException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<PsbtFinalizeException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return InputExceptionPsbtFinalizeException.read(subview);
      case 2:
        return WrongInputCountPsbtFinalizeException.read(subview);
      case 3:
        return InputIdxOutofBoundsPsbtFinalizeException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(PsbtFinalizeException value) {
    return value.lower();
  }

  static int allocationSize(PsbtFinalizeException value) {
    return value.allocationSize();
  }

  static int write(PsbtFinalizeException value, Uint8List buf) {
    return value.write(buf);
  }
}

class InputExceptionPsbtFinalizeException extends PsbtFinalizeException {
  final String reason;
  final int index;
  InputExceptionPsbtFinalizeException({
    required String this.reason,
    required int this.index,
  });
  InputExceptionPsbtFinalizeException._(String this.reason, int this.index);
  static LiftRetVal<InputExceptionPsbtFinalizeException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final reason_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final reason = reason_lifted.value;
    new_offset += reason_lifted.bytesRead;
    final index_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final index = index_lifted.value;
    new_offset += index_lifted.bytesRead;
    return LiftRetVal(
      InputExceptionPsbtFinalizeException._(reason, index),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(reason) +
        FfiConverterUInt32.allocationSize(index) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      reason,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      index,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InputExceptionPsbtFinalizeException($reason, $index)";
  }
}

class WrongInputCountPsbtFinalizeException extends PsbtFinalizeException {
  final int inTx;
  final int inMap;
  WrongInputCountPsbtFinalizeException({
    required int this.inTx,
    required int this.inMap,
  });
  WrongInputCountPsbtFinalizeException._(int this.inTx, int this.inMap);
  static LiftRetVal<WrongInputCountPsbtFinalizeException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final inTx_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final inTx = inTx_lifted.value;
    new_offset += inTx_lifted.bytesRead;
    final inMap_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final inMap = inMap_lifted.value;
    new_offset += inMap_lifted.bytesRead;
    return LiftRetVal(
      WrongInputCountPsbtFinalizeException._(inTx, inMap),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(inTx) +
        FfiConverterUInt32.allocationSize(inMap) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      inTx,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      inMap,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "WrongInputCountPsbtFinalizeException($inTx, $inMap)";
  }
}

class InputIdxOutofBoundsPsbtFinalizeException extends PsbtFinalizeException {
  final int psbtInp;
  final int requested;
  InputIdxOutofBoundsPsbtFinalizeException({
    required int this.psbtInp,
    required int this.requested,
  });
  InputIdxOutofBoundsPsbtFinalizeException._(
    int this.psbtInp,
    int this.requested,
  );
  static LiftRetVal<InputIdxOutofBoundsPsbtFinalizeException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final psbtInp_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final psbtInp = psbtInp_lifted.value;
    new_offset += psbtInp_lifted.bytesRead;
    final requested_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final requested = requested_lifted.value;
    new_offset += requested_lifted.bytesRead;
    return LiftRetVal(
      InputIdxOutofBoundsPsbtFinalizeException._(psbtInp, requested),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(psbtInp) +
        FfiConverterUInt32.allocationSize(requested) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      psbtInp,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt32.write(
      requested,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InputIdxOutofBoundsPsbtFinalizeException($psbtInp, $requested)";
  }
}

class PsbtFinalizeExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterPsbtFinalizeException.lift(errorBuf);
  }
}

final PsbtFinalizeExceptionErrorHandler psbtFinalizeExceptionErrorHandler =
    PsbtFinalizeExceptionErrorHandler();

abstract class PsbtParseException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterPsbtParseException {
  static PsbtParseException lift(RustBuffer buffer) {
    return FfiConverterPsbtParseException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<PsbtParseException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return PsbtEncodingPsbtParseException.read(subview);
      case 2:
        return Base64EncodingPsbtParseException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(PsbtParseException value) {
    return value.lower();
  }

  static int allocationSize(PsbtParseException value) {
    return value.allocationSize();
  }

  static int write(PsbtParseException value, Uint8List buf) {
    return value.write(buf);
  }
}

class PsbtEncodingPsbtParseException extends PsbtParseException {
  final String errorMessage;
  PsbtEncodingPsbtParseException(String this.errorMessage);
  PsbtEncodingPsbtParseException._(String this.errorMessage);
  static LiftRetVal<PsbtEncodingPsbtParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      PsbtEncodingPsbtParseException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PsbtEncodingPsbtParseException($errorMessage)";
  }
}

class Base64EncodingPsbtParseException extends PsbtParseException {
  final String errorMessage;
  Base64EncodingPsbtParseException(String this.errorMessage);
  Base64EncodingPsbtParseException._(String this.errorMessage);
  static LiftRetVal<Base64EncodingPsbtParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      Base64EncodingPsbtParseException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "Base64EncodingPsbtParseException($errorMessage)";
  }
}

class PsbtParseExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterPsbtParseException.lift(errorBuf);
  }
}

final PsbtParseExceptionErrorHandler psbtParseExceptionErrorHandler =
    PsbtParseExceptionErrorHandler();

enum RecoveryPoint { genesisBlock, segwitActivation, taprootActivation }

class FfiConverterRecoveryPoint {
  static LiftRetVal<RecoveryPoint> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(RecoveryPoint.genesisBlock, 4);
      case 2:
        return LiftRetVal(RecoveryPoint.segwitActivation, 4);
      case 3:
        return LiftRetVal(RecoveryPoint.taprootActivation, 4);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RecoveryPoint lift(RustBuffer buffer) {
    return FfiConverterRecoveryPoint.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(RecoveryPoint input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(RecoveryPoint _value) {
    return 4;
  }

  static int write(RecoveryPoint value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

abstract class RequestBuilderException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterRequestBuilderException {
  static RequestBuilderException lift(RustBuffer buffer) {
    return FfiConverterRequestBuilderException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<RequestBuilderException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return RequestAlreadyConsumedRequestBuilderException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(RequestBuilderException value) {
    return value.lower();
  }

  static int allocationSize(RequestBuilderException value) {
    return value.allocationSize();
  }

  static int write(RequestBuilderException value, Uint8List buf) {
    return value.write(buf);
  }
}

class RequestAlreadyConsumedRequestBuilderException
    extends RequestBuilderException {
  RequestAlreadyConsumedRequestBuilderException();
  RequestAlreadyConsumedRequestBuilderException._();
  static LiftRetVal<RequestAlreadyConsumedRequestBuilderException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      RequestAlreadyConsumedRequestBuilderException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "RequestAlreadyConsumedRequestBuilderException";
  }
}

class RequestBuilderExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterRequestBuilderException.lift(errorBuf);
  }
}

final RequestBuilderExceptionErrorHandler requestBuilderExceptionErrorHandler =
    RequestBuilderExceptionErrorHandler();

abstract class Satisfaction {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterSatisfaction {
  static Satisfaction lift(RustBuffer buffer) {
    return FfiConverterSatisfaction.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<Satisfaction> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return PartialSatisfaction.read(subview);
      case 2:
        return PartialCompleteSatisfaction.read(subview);
      case 3:
        return CompleteSatisfaction.read(subview);
      case 4:
        return NoneSatisfaction.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(Satisfaction value) {
    return value.lower();
  }

  static int allocationSize(Satisfaction value) {
    return value.allocationSize();
  }

  static int write(Satisfaction value, Uint8List buf) {
    return value.write(buf);
  }
}

class PartialSatisfaction extends Satisfaction {
  final int n;
  final int m;
  final List<int> items;
  final bool? sorted;
  final Map<int, List<Condition>> conditions;
  PartialSatisfaction({
    required int this.n,
    required int this.m,
    required List<int> this.items,
    required bool? this.sorted,
    required Map<int, List<Condition>> this.conditions,
  });
  PartialSatisfaction._(
    int this.n,
    int this.m,
    List<int> this.items,
    bool? this.sorted,
    Map<int, List<Condition>> this.conditions,
  );
  static LiftRetVal<PartialSatisfaction> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final n_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final n = n_lifted.value;
    new_offset += n_lifted.bytesRead;
    final m_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final m = m_lifted.value;
    new_offset += m_lifted.bytesRead;
    final items_lifted = FfiConverterSequenceUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final items = items_lifted.value;
    new_offset += items_lifted.bytesRead;
    final sorted_lifted = FfiConverterOptionalBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final sorted = sorted_lifted.value;
    new_offset += sorted_lifted.bytesRead;
    final conditions_lifted = FfiConverterMapUInt32ToSequenceCondition.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final conditions = conditions_lifted.value;
    new_offset += conditions_lifted.bytesRead;
    return LiftRetVal(
      PartialSatisfaction._(n, m, items, sorted, conditions),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(n) +
        FfiConverterUInt64.allocationSize(m) +
        FfiConverterSequenceUInt64.allocationSize(items) +
        FfiConverterOptionalBool.allocationSize(sorted) +
        FfiConverterMapUInt32ToSequenceCondition.allocationSize(conditions) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      n,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      m,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterSequenceUInt64.write(
      items,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalBool.write(
      sorted,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapUInt32ToSequenceCondition.write(
      conditions,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class PartialCompleteSatisfaction extends Satisfaction {
  final int n;
  final int m;
  final List<int> items;
  final bool? sorted;
  final Map<List<int>, List<Condition>> conditions;
  PartialCompleteSatisfaction({
    required int this.n,
    required int this.m,
    required List<int> this.items,
    required bool? this.sorted,
    required Map<List<int>, List<Condition>> this.conditions,
  });
  PartialCompleteSatisfaction._(
    int this.n,
    int this.m,
    List<int> this.items,
    bool? this.sorted,
    Map<List<int>, List<Condition>> this.conditions,
  );
  static LiftRetVal<PartialCompleteSatisfaction> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final n_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final n = n_lifted.value;
    new_offset += n_lifted.bytesRead;
    final m_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final m = m_lifted.value;
    new_offset += m_lifted.bytesRead;
    final items_lifted = FfiConverterSequenceUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final items = items_lifted.value;
    new_offset += items_lifted.bytesRead;
    final sorted_lifted = FfiConverterOptionalBool.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final sorted = sorted_lifted.value;
    new_offset += sorted_lifted.bytesRead;
    final conditions_lifted =
        FfiConverterMapSequenceUInt32ToSequenceCondition.read(
          Uint8List.view(buf.buffer, new_offset),
        );
    final conditions = conditions_lifted.value;
    new_offset += conditions_lifted.bytesRead;
    return LiftRetVal(
      PartialCompleteSatisfaction._(n, m, items, sorted, conditions),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt64.allocationSize(n) +
        FfiConverterUInt64.allocationSize(m) +
        FfiConverterSequenceUInt64.allocationSize(items) +
        FfiConverterOptionalBool.allocationSize(sorted) +
        FfiConverterMapSequenceUInt32ToSequenceCondition.allocationSize(
          conditions,
        ) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt64.write(
      n,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      m,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterSequenceUInt64.write(
      items,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalBool.write(
      sorted,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterMapSequenceUInt32ToSequenceCondition.write(
      conditions,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class CompleteSatisfaction extends Satisfaction {
  final Condition condition;
  CompleteSatisfaction(Condition this.condition);
  CompleteSatisfaction._(Condition this.condition);
  static LiftRetVal<CompleteSatisfaction> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final condition_lifted = FfiConverterCondition.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final condition = condition_lifted.value;
    new_offset += condition_lifted.bytesRead;
    return LiftRetVal(CompleteSatisfaction._(condition), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterCondition.allocationSize(condition) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterCondition.write(
      condition,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class NoneSatisfaction extends Satisfaction {
  final String msg;
  NoneSatisfaction(String this.msg);
  NoneSatisfaction._(String this.msg);
  static LiftRetVal<NoneSatisfaction> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final msg_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final msg = msg_lifted.value;
    new_offset += msg_lifted.bytesRead;
    return LiftRetVal(NoneSatisfaction._(msg), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(msg) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      msg,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

abstract class SatisfiableItem {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterSatisfiableItem {
  static SatisfiableItem lift(RustBuffer buffer) {
    return FfiConverterSatisfiableItem.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<SatisfiableItem> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return EcdsaSignatureSatisfiableItem.read(subview);
      case 2:
        return SchnorrSignatureSatisfiableItem.read(subview);
      case 3:
        return Sha256PreimageSatisfiableItem.read(subview);
      case 4:
        return Hash256PreimageSatisfiableItem.read(subview);
      case 5:
        return Ripemd160PreimageSatisfiableItem.read(subview);
      case 6:
        return Hash160PreimageSatisfiableItem.read(subview);
      case 7:
        return AbsoluteTimelockSatisfiableItem.read(subview);
      case 8:
        return RelativeTimelockSatisfiableItem.read(subview);
      case 9:
        return MultisigSatisfiableItem.read(subview);
      case 10:
        return ThreshSatisfiableItem.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(SatisfiableItem value) {
    return value.lower();
  }

  static int allocationSize(SatisfiableItem value) {
    return value.allocationSize();
  }

  static int write(SatisfiableItem value, Uint8List buf) {
    return value.write(buf);
  }
}

class EcdsaSignatureSatisfiableItem extends SatisfiableItem {
  final PkOrF key;
  EcdsaSignatureSatisfiableItem(PkOrF this.key);
  EcdsaSignatureSatisfiableItem._(PkOrF this.key);
  static LiftRetVal<EcdsaSignatureSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final key_lifted = FfiConverterPkOrF.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final key = key_lifted.value;
    new_offset += key_lifted.bytesRead;
    return LiftRetVal(EcdsaSignatureSatisfiableItem._(key), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterPkOrF.allocationSize(key) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterPkOrF.write(
      key,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class SchnorrSignatureSatisfiableItem extends SatisfiableItem {
  final PkOrF key;
  SchnorrSignatureSatisfiableItem(PkOrF this.key);
  SchnorrSignatureSatisfiableItem._(PkOrF this.key);
  static LiftRetVal<SchnorrSignatureSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final key_lifted = FfiConverterPkOrF.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final key = key_lifted.value;
    new_offset += key_lifted.bytesRead;
    return LiftRetVal(SchnorrSignatureSatisfiableItem._(key), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterPkOrF.allocationSize(key) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterPkOrF.write(
      key,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class Sha256PreimageSatisfiableItem extends SatisfiableItem {
  final String hash;
  Sha256PreimageSatisfiableItem(String this.hash);
  Sha256PreimageSatisfiableItem._(String this.hash);
  static LiftRetVal<Sha256PreimageSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final hash_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hash = hash_lifted.value;
    new_offset += hash_lifted.bytesRead;
    return LiftRetVal(Sha256PreimageSatisfiableItem._(hash), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(hash) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      hash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class Hash256PreimageSatisfiableItem extends SatisfiableItem {
  final String hash;
  Hash256PreimageSatisfiableItem(String this.hash);
  Hash256PreimageSatisfiableItem._(String this.hash);
  static LiftRetVal<Hash256PreimageSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final hash_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hash = hash_lifted.value;
    new_offset += hash_lifted.bytesRead;
    return LiftRetVal(Hash256PreimageSatisfiableItem._(hash), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(hash) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      hash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class Ripemd160PreimageSatisfiableItem extends SatisfiableItem {
  final String hash;
  Ripemd160PreimageSatisfiableItem(String this.hash);
  Ripemd160PreimageSatisfiableItem._(String this.hash);
  static LiftRetVal<Ripemd160PreimageSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final hash_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hash = hash_lifted.value;
    new_offset += hash_lifted.bytesRead;
    return LiftRetVal(Ripemd160PreimageSatisfiableItem._(hash), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(hash) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      hash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class Hash160PreimageSatisfiableItem extends SatisfiableItem {
  final String hash;
  Hash160PreimageSatisfiableItem(String this.hash);
  Hash160PreimageSatisfiableItem._(String this.hash);
  static LiftRetVal<Hash160PreimageSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final hash_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final hash = hash_lifted.value;
    new_offset += hash_lifted.bytesRead;
    return LiftRetVal(Hash160PreimageSatisfiableItem._(hash), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(hash) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      hash,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class AbsoluteTimelockSatisfiableItem extends SatisfiableItem {
  final LockTime value;
  AbsoluteTimelockSatisfiableItem(LockTime this.value);
  AbsoluteTimelockSatisfiableItem._(LockTime this.value);
  static LiftRetVal<AbsoluteTimelockSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final value_lifted = FfiConverterLockTime.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final value = value_lifted.value;
    new_offset += value_lifted.bytesRead;
    return LiftRetVal(AbsoluteTimelockSatisfiableItem._(value), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterLockTime.allocationSize(value) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterLockTime.write(
      value,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class RelativeTimelockSatisfiableItem extends SatisfiableItem {
  final int value;
  RelativeTimelockSatisfiableItem(int this.value);
  RelativeTimelockSatisfiableItem._(int this.value);
  static LiftRetVal<RelativeTimelockSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final value_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final value = value_lifted.value;
    new_offset += value_lifted.bytesRead;
    return LiftRetVal(RelativeTimelockSatisfiableItem._(value), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(value) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      value,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class MultisigSatisfiableItem extends SatisfiableItem {
  final List<PkOrF> keys;
  final int threshold;
  MultisigSatisfiableItem({
    required List<PkOrF> this.keys,
    required int this.threshold,
  });
  MultisigSatisfiableItem._(List<PkOrF> this.keys, int this.threshold);
  static LiftRetVal<MultisigSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final keys_lifted = FfiConverterSequencePkOrF.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final keys = keys_lifted.value;
    new_offset += keys_lifted.bytesRead;
    final threshold_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final threshold = threshold_lifted.value;
    new_offset += threshold_lifted.bytesRead;
    return LiftRetVal(MultisigSatisfiableItem._(keys, threshold), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterSequencePkOrF.allocationSize(keys) +
        FfiConverterUInt64.allocationSize(threshold) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterSequencePkOrF.write(
      keys,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      threshold,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class ThreshSatisfiableItem extends SatisfiableItem {
  final List<Policy> items;
  final int threshold;
  ThreshSatisfiableItem({
    required List<Policy> this.items,
    required int this.threshold,
  });
  ThreshSatisfiableItem._(List<Policy> this.items, int this.threshold);
  static LiftRetVal<ThreshSatisfiableItem> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final items_lifted = FfiConverterSequencePolicy.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final items = items_lifted.value;
    new_offset += items_lifted.bytesRead;
    final threshold_lifted = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final threshold = threshold_lifted.value;
    new_offset += threshold_lifted.bytesRead;
    return LiftRetVal(ThreshSatisfiableItem._(items, threshold), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterSequencePolicy.allocationSize(items) +
        FfiConverterUInt64.allocationSize(threshold) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterSequencePolicy.write(
      items,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterUInt64.write(
      threshold,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

abstract class ScanType {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterScanType {
  static ScanType lift(RustBuffer buffer) {
    return FfiConverterScanType.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<ScanType> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return SyncScanType.read(subview);
      case 2:
        return RecoveryScanType.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(ScanType value) {
    return value.lower();
  }

  static int allocationSize(ScanType value) {
    return value.allocationSize();
  }

  static int write(ScanType value, Uint8List buf) {
    return value.write(buf);
  }
}

class SyncScanType extends ScanType {
  SyncScanType();
  SyncScanType._();
  static LiftRetVal<SyncScanType> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(SyncScanType._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class RecoveryScanType extends ScanType {
  final int usedScriptIndex;
  final RecoveryPoint checkpoint;
  RecoveryScanType({
    required int this.usedScriptIndex,
    required RecoveryPoint this.checkpoint,
  });
  RecoveryScanType._(int this.usedScriptIndex, RecoveryPoint this.checkpoint);
  static LiftRetVal<RecoveryScanType> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final usedScriptIndex_lifted = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final usedScriptIndex = usedScriptIndex_lifted.value;
    new_offset += usedScriptIndex_lifted.bytesRead;
    final checkpoint_int = buf.buffer.asByteData(new_offset).getInt32(0);
    final checkpoint = FfiConverterRecoveryPoint.lift(
      toRustBuffer(createUint8ListFromInt(checkpoint_int)),
    );
    new_offset += 4;
    return LiftRetVal(
      RecoveryScanType._(usedScriptIndex, checkpoint),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt32.allocationSize(usedScriptIndex) + 4 + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt32.write(
      usedScriptIndex,
      Uint8List.view(buf.buffer, new_offset),
    );
    final checkpoint_buffer = FfiConverterRecoveryPoint.lower(checkpoint);
    final checkpoint_int = checkpoint_buffer
        .asUint8List()
        .buffer
        .asByteData()
        .getInt32(0);
    buf.buffer.asByteData(new_offset).setInt32(0, checkpoint_int);
    new_offset += 4;
    return new_offset;
  }
}

abstract class SignerException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterSignerException {
  static SignerException lift(RustBuffer buffer) {
    return FfiConverterSignerException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<SignerException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return MissingKeySignerException.read(subview);
      case 2:
        return InvalidKeySignerException.read(subview);
      case 3:
        return UserCanceledSignerException.read(subview);
      case 4:
        return InputIndexOutOfRangeSignerException.read(subview);
      case 5:
        return MissingNonWitnessUtxoSignerException.read(subview);
      case 6:
        return InvalidNonWitnessUtxoSignerException.read(subview);
      case 7:
        return MissingWitnessUtxoSignerException.read(subview);
      case 8:
        return MissingWitnessScriptSignerException.read(subview);
      case 9:
        return MissingHdKeypathSignerException.read(subview);
      case 10:
        return NonStandardSighashSignerException.read(subview);
      case 11:
        return InvalidSighashSignerException.read(subview);
      case 12:
        return SighashP2wpkhSignerException.read(subview);
      case 13:
        return SighashTaprootSignerException.read(subview);
      case 14:
        return TxInputsIndexExceptionSignerException.read(subview);
      case 15:
        return MiniscriptPsbtSignerException.read(subview);
      case 16:
        return ExternalSignerException.read(subview);
      case 17:
        return PsbtSignerException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(SignerException value) {
    return value.lower();
  }

  static int allocationSize(SignerException value) {
    return value.allocationSize();
  }

  static int write(SignerException value, Uint8List buf) {
    return value.write(buf);
  }
}

class MissingKeySignerException extends SignerException {
  MissingKeySignerException();
  MissingKeySignerException._();
  static LiftRetVal<MissingKeySignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingKeySignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingKeySignerException";
  }
}

class InvalidKeySignerException extends SignerException {
  InvalidKeySignerException();
  InvalidKeySignerException._();
  static LiftRetVal<InvalidKeySignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidKeySignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidKeySignerException";
  }
}

class UserCanceledSignerException extends SignerException {
  UserCanceledSignerException();
  UserCanceledSignerException._();
  static LiftRetVal<UserCanceledSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(UserCanceledSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "UserCanceledSignerException";
  }
}

class InputIndexOutOfRangeSignerException extends SignerException {
  InputIndexOutOfRangeSignerException();
  InputIndexOutOfRangeSignerException._();
  static LiftRetVal<InputIndexOutOfRangeSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InputIndexOutOfRangeSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InputIndexOutOfRangeSignerException";
  }
}

class MissingNonWitnessUtxoSignerException extends SignerException {
  MissingNonWitnessUtxoSignerException();
  MissingNonWitnessUtxoSignerException._();
  static LiftRetVal<MissingNonWitnessUtxoSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingNonWitnessUtxoSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingNonWitnessUtxoSignerException";
  }
}

class InvalidNonWitnessUtxoSignerException extends SignerException {
  InvalidNonWitnessUtxoSignerException();
  InvalidNonWitnessUtxoSignerException._();
  static LiftRetVal<InvalidNonWitnessUtxoSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidNonWitnessUtxoSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidNonWitnessUtxoSignerException";
  }
}

class MissingWitnessUtxoSignerException extends SignerException {
  MissingWitnessUtxoSignerException();
  MissingWitnessUtxoSignerException._();
  static LiftRetVal<MissingWitnessUtxoSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingWitnessUtxoSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingWitnessUtxoSignerException";
  }
}

class MissingWitnessScriptSignerException extends SignerException {
  MissingWitnessScriptSignerException();
  MissingWitnessScriptSignerException._();
  static LiftRetVal<MissingWitnessScriptSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingWitnessScriptSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingWitnessScriptSignerException";
  }
}

class MissingHdKeypathSignerException extends SignerException {
  MissingHdKeypathSignerException();
  MissingHdKeypathSignerException._();
  static LiftRetVal<MissingHdKeypathSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(MissingHdKeypathSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "MissingHdKeypathSignerException";
  }
}

class NonStandardSighashSignerException extends SignerException {
  NonStandardSighashSignerException();
  NonStandardSighashSignerException._();
  static LiftRetVal<NonStandardSighashSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NonStandardSighashSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NonStandardSighashSignerException";
  }
}

class InvalidSighashSignerException extends SignerException {
  InvalidSighashSignerException();
  InvalidSighashSignerException._();
  static LiftRetVal<InvalidSighashSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(InvalidSighashSignerException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 11);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidSighashSignerException";
  }
}

class SighashP2wpkhSignerException extends SignerException {
  final String errorMessage;
  SighashP2wpkhSignerException(String this.errorMessage);
  SighashP2wpkhSignerException._(String this.errorMessage);
  static LiftRetVal<SighashP2wpkhSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(SighashP2wpkhSignerException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 12);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "SighashP2wpkhSignerException($errorMessage)";
  }
}

class SighashTaprootSignerException extends SignerException {
  final String errorMessage;
  SighashTaprootSignerException(String this.errorMessage);
  SighashTaprootSignerException._(String this.errorMessage);
  static LiftRetVal<SighashTaprootSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      SighashTaprootSignerException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 13);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "SighashTaprootSignerException($errorMessage)";
  }
}

class TxInputsIndexExceptionSignerException extends SignerException {
  final String errorMessage;
  TxInputsIndexExceptionSignerException(String this.errorMessage);
  TxInputsIndexExceptionSignerException._(String this.errorMessage);
  static LiftRetVal<TxInputsIndexExceptionSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      TxInputsIndexExceptionSignerException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 14);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "TxInputsIndexExceptionSignerException($errorMessage)";
  }
}

class MiniscriptPsbtSignerException extends SignerException {
  final String errorMessage;
  MiniscriptPsbtSignerException(String this.errorMessage);
  MiniscriptPsbtSignerException._(String this.errorMessage);
  static LiftRetVal<MiniscriptPsbtSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(
      MiniscriptPsbtSignerException._(errorMessage),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 15);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "MiniscriptPsbtSignerException($errorMessage)";
  }
}

class ExternalSignerException extends SignerException {
  final String errorMessage;
  ExternalSignerException(String this.errorMessage);
  ExternalSignerException._(String this.errorMessage);
  static LiftRetVal<ExternalSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(ExternalSignerException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 16);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "ExternalSignerException($errorMessage)";
  }
}

class PsbtSignerException extends SignerException {
  final String errorMessage;
  PsbtSignerException(String this.errorMessage);
  PsbtSignerException._(String this.errorMessage);
  static LiftRetVal<PsbtSignerException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final errorMessage_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final errorMessage = errorMessage_lifted.value;
    new_offset += errorMessage_lifted.bytesRead;
    return LiftRetVal(PsbtSignerException._(errorMessage), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(errorMessage) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 17);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      errorMessage,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "PsbtSignerException($errorMessage)";
  }
}

class SignerExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterSignerException.lift(errorBuf);
  }
}

final SignerExceptionErrorHandler signerExceptionErrorHandler =
    SignerExceptionErrorHandler();

abstract class TransactionException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterTransactionException {
  static TransactionException lift(RustBuffer buffer) {
    return FfiConverterTransactionException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<TransactionException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return IoTransactionException.read(subview);
      case 2:
        return OversizedVectorAllocationTransactionException.read(subview);
      case 3:
        return InvalidChecksumTransactionException.read(subview);
      case 4:
        return NonMinimalVarIntTransactionException.read(subview);
      case 5:
        return ParseFailedTransactionException.read(subview);
      case 6:
        return UnsupportedSegwitFlagTransactionException.read(subview);
      case 7:
        return OtherTransactionErrTransactionException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(TransactionException value) {
    return value.lower();
  }

  static int allocationSize(TransactionException value) {
    return value.allocationSize();
  }

  static int write(TransactionException value, Uint8List buf) {
    return value.write(buf);
  }
}

class IoTransactionException extends TransactionException {
  IoTransactionException();
  IoTransactionException._();
  static LiftRetVal<IoTransactionException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(IoTransactionException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "IoTransactionException";
  }
}

class OversizedVectorAllocationTransactionException
    extends TransactionException {
  OversizedVectorAllocationTransactionException();
  OversizedVectorAllocationTransactionException._();
  static LiftRetVal<OversizedVectorAllocationTransactionException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(
      OversizedVectorAllocationTransactionException._(),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "OversizedVectorAllocationTransactionException";
  }
}

class InvalidChecksumTransactionException extends TransactionException {
  final String expected;
  final String actual;
  InvalidChecksumTransactionException({
    required String this.expected,
    required String this.actual,
  });
  InvalidChecksumTransactionException._(
    String this.expected,
    String this.actual,
  );
  static LiftRetVal<InvalidChecksumTransactionException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final expected_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final expected = expected_lifted.value;
    new_offset += expected_lifted.bytesRead;
    final actual_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final actual = actual_lifted.value;
    new_offset += actual_lifted.bytesRead;
    return LiftRetVal(
      InvalidChecksumTransactionException._(expected, actual),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(expected) +
        FfiConverterString.allocationSize(actual) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      expected,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterString.write(
      actual,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidChecksumTransactionException($expected, $actual)";
  }
}

class NonMinimalVarIntTransactionException extends TransactionException {
  NonMinimalVarIntTransactionException();
  NonMinimalVarIntTransactionException._();
  static LiftRetVal<NonMinimalVarIntTransactionException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NonMinimalVarIntTransactionException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "NonMinimalVarIntTransactionException";
  }
}

class ParseFailedTransactionException extends TransactionException {
  ParseFailedTransactionException();
  ParseFailedTransactionException._();
  static LiftRetVal<ParseFailedTransactionException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(ParseFailedTransactionException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "ParseFailedTransactionException";
  }
}

class UnsupportedSegwitFlagTransactionException extends TransactionException {
  final int flag;
  UnsupportedSegwitFlagTransactionException(int this.flag);
  UnsupportedSegwitFlagTransactionException._(int this.flag);
  static LiftRetVal<UnsupportedSegwitFlagTransactionException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    final flag_lifted = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final flag = flag_lifted.value;
    new_offset += flag_lifted.bytesRead;
    return LiftRetVal(
      UnsupportedSegwitFlagTransactionException._(flag),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterUInt8.allocationSize(flag) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterUInt8.write(
      flag,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "UnsupportedSegwitFlagTransactionException($flag)";
  }
}

class OtherTransactionErrTransactionException extends TransactionException {
  OtherTransactionErrTransactionException();
  OtherTransactionErrTransactionException._();
  static LiftRetVal<OtherTransactionErrTransactionException> read(
    Uint8List buf,
  ) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(OtherTransactionErrTransactionException._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }

  @override
  String toString() {
    return "OtherTransactionErrTransactionException";
  }
}

class TransactionExceptionErrorHandler
    extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterTransactionException.lift(errorBuf);
  }
}

final TransactionExceptionErrorHandler transactionExceptionErrorHandler =
    TransactionExceptionErrorHandler();

abstract class TxidParseException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterTxidParseException {
  static TxidParseException lift(RustBuffer buffer) {
    return FfiConverterTxidParseException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<TxidParseException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return InvalidTxidTxidParseException.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(TxidParseException value) {
    return value.lower();
  }

  static int allocationSize(TxidParseException value) {
    return value.allocationSize();
  }

  static int write(TxidParseException value, Uint8List buf) {
    return value.write(buf);
  }
}

class InvalidTxidTxidParseException extends TxidParseException {
  final String txid;
  InvalidTxidTxidParseException(String this.txid);
  InvalidTxidTxidParseException._(String this.txid);
  static LiftRetVal<InvalidTxidTxidParseException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    return LiftRetVal(InvalidTxidTxidParseException._(txid), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(txid) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      txid,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }

  @override
  String toString() {
    return "InvalidTxidTxidParseException($txid)";
  }
}

class TxidParseExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterTxidParseException.lift(errorBuf);
  }
}

final TxidParseExceptionErrorHandler txidParseExceptionErrorHandler =
    TxidParseExceptionErrorHandler();

abstract class WalletEvent {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterWalletEvent {
  static WalletEvent lift(RustBuffer buffer) {
    return FfiConverterWalletEvent.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<WalletEvent> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return ChainTipChangedWalletEvent.read(subview);
      case 2:
        return TxConfirmedWalletEvent.read(subview);
      case 3:
        return TxUnconfirmedWalletEvent.read(subview);
      case 4:
        return TxReplacedWalletEvent.read(subview);
      case 5:
        return TxDroppedWalletEvent.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(WalletEvent value) {
    return value.lower();
  }

  static int allocationSize(WalletEvent value) {
    return value.allocationSize();
  }

  static int write(WalletEvent value, Uint8List buf) {
    return value.write(buf);
  }
}

class ChainTipChangedWalletEvent extends WalletEvent {
  final BlockId oldTip;
  final BlockId newTip;
  ChainTipChangedWalletEvent({
    required BlockId this.oldTip,
    required BlockId this.newTip,
  });
  ChainTipChangedWalletEvent._(BlockId this.oldTip, BlockId this.newTip);
  static LiftRetVal<ChainTipChangedWalletEvent> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final oldTip_lifted = FfiConverterBlockId.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final oldTip = oldTip_lifted.value;
    new_offset += oldTip_lifted.bytesRead;
    final newTip_lifted = FfiConverterBlockId.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final newTip = newTip_lifted.value;
    new_offset += newTip_lifted.bytesRead;
    return LiftRetVal(ChainTipChangedWalletEvent._(oldTip, newTip), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterBlockId.allocationSize(oldTip) +
        FfiConverterBlockId.allocationSize(newTip) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterBlockId.write(
      oldTip,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterBlockId.write(
      newTip,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class TxConfirmedWalletEvent extends WalletEvent {
  final Txid txid;
  final Transaction tx;
  final ConfirmationBlockTime blockTime;
  final ConfirmationBlockTime? oldBlockTime;
  TxConfirmedWalletEvent({
    required Txid this.txid,
    required Transaction this.tx,
    required ConfirmationBlockTime this.blockTime,
    required ConfirmationBlockTime? this.oldBlockTime,
  });
  TxConfirmedWalletEvent._(
    Txid this.txid,
    Transaction this.tx,
    ConfirmationBlockTime this.blockTime,
    ConfirmationBlockTime? this.oldBlockTime,
  );
  static LiftRetVal<TxConfirmedWalletEvent> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    final tx_lifted = Transaction.read(Uint8List.view(buf.buffer, new_offset));
    final tx = tx_lifted.value;
    new_offset += tx_lifted.bytesRead;
    final blockTime_lifted = FfiConverterConfirmationBlockTime.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final blockTime = blockTime_lifted.value;
    new_offset += blockTime_lifted.bytesRead;
    final oldBlockTime_lifted = FfiConverterOptionalConfirmationBlockTime.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final oldBlockTime = oldBlockTime_lifted.value;
    new_offset += oldBlockTime_lifted.bytesRead;
    return LiftRetVal(
      TxConfirmedWalletEvent._(txid, tx, blockTime, oldBlockTime),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return Txid.allocationSize(txid) +
        Transaction.allocationSize(tx) +
        FfiConverterConfirmationBlockTime.allocationSize(blockTime) +
        FfiConverterOptionalConfirmationBlockTime.allocationSize(oldBlockTime) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += Txid.write(txid, Uint8List.view(buf.buffer, new_offset));
    new_offset += Transaction.write(tx, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterConfirmationBlockTime.write(
      blockTime,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalConfirmationBlockTime.write(
      oldBlockTime,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class TxUnconfirmedWalletEvent extends WalletEvent {
  final Txid txid;
  final Transaction tx;
  final ConfirmationBlockTime? oldBlockTime;
  TxUnconfirmedWalletEvent({
    required Txid this.txid,
    required Transaction this.tx,
    required ConfirmationBlockTime? this.oldBlockTime,
  });
  TxUnconfirmedWalletEvent._(
    Txid this.txid,
    Transaction this.tx,
    ConfirmationBlockTime? this.oldBlockTime,
  );
  static LiftRetVal<TxUnconfirmedWalletEvent> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    final tx_lifted = Transaction.read(Uint8List.view(buf.buffer, new_offset));
    final tx = tx_lifted.value;
    new_offset += tx_lifted.bytesRead;
    final oldBlockTime_lifted = FfiConverterOptionalConfirmationBlockTime.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final oldBlockTime = oldBlockTime_lifted.value;
    new_offset += oldBlockTime_lifted.bytesRead;
    return LiftRetVal(
      TxUnconfirmedWalletEvent._(txid, tx, oldBlockTime),
      new_offset,
    );
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return Txid.allocationSize(txid) +
        Transaction.allocationSize(tx) +
        FfiConverterOptionalConfirmationBlockTime.allocationSize(oldBlockTime) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += Txid.write(txid, Uint8List.view(buf.buffer, new_offset));
    new_offset += Transaction.write(tx, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalConfirmationBlockTime.write(
      oldBlockTime,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class TxReplacedWalletEvent extends WalletEvent {
  final Txid txid;
  final Transaction tx;
  final List<Conflict> conflicts;
  TxReplacedWalletEvent({
    required Txid this.txid,
    required Transaction this.tx,
    required List<Conflict> this.conflicts,
  });
  TxReplacedWalletEvent._(
    Txid this.txid,
    Transaction this.tx,
    List<Conflict> this.conflicts,
  );
  static LiftRetVal<TxReplacedWalletEvent> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    final tx_lifted = Transaction.read(Uint8List.view(buf.buffer, new_offset));
    final tx = tx_lifted.value;
    new_offset += tx_lifted.bytesRead;
    final conflicts_lifted = FfiConverterSequenceConflict.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final conflicts = conflicts_lifted.value;
    new_offset += conflicts_lifted.bytesRead;
    return LiftRetVal(TxReplacedWalletEvent._(txid, tx, conflicts), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return Txid.allocationSize(txid) +
        Transaction.allocationSize(tx) +
        FfiConverterSequenceConflict.allocationSize(conflicts) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += Txid.write(txid, Uint8List.view(buf.buffer, new_offset));
    new_offset += Transaction.write(tx, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceConflict.write(
      conflicts,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class TxDroppedWalletEvent extends WalletEvent {
  final Txid txid;
  final Transaction tx;
  TxDroppedWalletEvent({required Txid this.txid, required Transaction this.tx});
  TxDroppedWalletEvent._(Txid this.txid, Transaction this.tx);
  static LiftRetVal<TxDroppedWalletEvent> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final txid_lifted = Txid.read(Uint8List.view(buf.buffer, new_offset));
    final txid = txid_lifted.value;
    new_offset += txid_lifted.bytesRead;
    final tx_lifted = Transaction.read(Uint8List.view(buf.buffer, new_offset));
    final tx = tx_lifted.value;
    new_offset += tx_lifted.bytesRead;
    return LiftRetVal(TxDroppedWalletEvent._(txid, tx), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return Txid.allocationSize(txid) + Transaction.allocationSize(tx) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += Txid.write(txid, Uint8List.view(buf.buffer, new_offset));
    new_offset += Transaction.write(tx, Uint8List.view(buf.buffer, new_offset));
    return new_offset;
  }
}

abstract class Warning {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterWarning {
  static Warning lift(RustBuffer buffer) {
    return FfiConverterWarning.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<Warning> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        return NeedConnectionsWarning.read(subview);
      case 2:
        return PeerTimedOutWarning.read(subview);
      case 3:
        return CouldNotConnectWarning.read(subview);
      case 4:
        return NoCompactFiltersWarning.read(subview);
      case 5:
        return PotentialStaleTipWarning.read(subview);
      case 6:
        return UnsolicitedMessageWarning.read(subview);
      case 7:
        return TransactionRejectedWarning.read(subview);
      case 8:
        return EvaluatingForkWarning.read(subview);
      case 9:
        return UnexpectedSyncExceptionWarning.read(subview);
      case 10:
        return RequestFailedWarning.read(subview);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static RustBuffer lower(Warning value) {
    return value.lower();
  }

  static int allocationSize(Warning value) {
    return value.allocationSize();
  }

  static int write(Warning value, Uint8List buf) {
    return value.write(buf);
  }
}

class NeedConnectionsWarning extends Warning {
  NeedConnectionsWarning();
  NeedConnectionsWarning._();
  static LiftRetVal<NeedConnectionsWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NeedConnectionsWarning._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class PeerTimedOutWarning extends Warning {
  PeerTimedOutWarning();
  PeerTimedOutWarning._();
  static LiftRetVal<PeerTimedOutWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(PeerTimedOutWarning._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 2);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class CouldNotConnectWarning extends Warning {
  CouldNotConnectWarning();
  CouldNotConnectWarning._();
  static LiftRetVal<CouldNotConnectWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(CouldNotConnectWarning._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 3);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class NoCompactFiltersWarning extends Warning {
  NoCompactFiltersWarning();
  NoCompactFiltersWarning._();
  static LiftRetVal<NoCompactFiltersWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(NoCompactFiltersWarning._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 4);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class PotentialStaleTipWarning extends Warning {
  PotentialStaleTipWarning();
  PotentialStaleTipWarning._();
  static LiftRetVal<PotentialStaleTipWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(PotentialStaleTipWarning._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 5);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class UnsolicitedMessageWarning extends Warning {
  UnsolicitedMessageWarning();
  UnsolicitedMessageWarning._();
  static LiftRetVal<UnsolicitedMessageWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(UnsolicitedMessageWarning._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 6);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class TransactionRejectedWarning extends Warning {
  final String wtxid;
  final String? reason;
  TransactionRejectedWarning({
    required String this.wtxid,
    required String? this.reason,
  });
  TransactionRejectedWarning._(String this.wtxid, String? this.reason);
  static LiftRetVal<TransactionRejectedWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final wtxid_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final wtxid = wtxid_lifted.value;
    new_offset += wtxid_lifted.bytesRead;
    final reason_lifted = FfiConverterOptionalString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final reason = reason_lifted.value;
    new_offset += reason_lifted.bytesRead;
    return LiftRetVal(TransactionRejectedWarning._(wtxid, reason), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(wtxid) +
        FfiConverterOptionalString.allocationSize(reason) +
        4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 7);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      wtxid,
      Uint8List.view(buf.buffer, new_offset),
    );
    new_offset += FfiConverterOptionalString.write(
      reason,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class EvaluatingForkWarning extends Warning {
  EvaluatingForkWarning();
  EvaluatingForkWarning._();
  static LiftRetVal<EvaluatingForkWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(EvaluatingForkWarning._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 8);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

class UnexpectedSyncExceptionWarning extends Warning {
  final String warning;
  UnexpectedSyncExceptionWarning(String this.warning);
  UnexpectedSyncExceptionWarning._(String this.warning);
  static LiftRetVal<UnexpectedSyncExceptionWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final warning_lifted = FfiConverterString.read(
      Uint8List.view(buf.buffer, new_offset),
    );
    final warning = warning_lifted.value;
    new_offset += warning_lifted.bytesRead;
    return LiftRetVal(UnexpectedSyncExceptionWarning._(warning), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(warning) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 9);
    int new_offset = buf.offsetInBytes + 4;
    new_offset += FfiConverterString.write(
      warning,
      Uint8List.view(buf.buffer, new_offset),
    );
    return new_offset;
  }
}

class RequestFailedWarning extends Warning {
  RequestFailedWarning();
  RequestFailedWarning._();
  static LiftRetVal<RequestFailedWarning> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(RequestFailedWarning._(), new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 10);
    int new_offset = buf.offsetInBytes + 4;
    return new_offset;
  }
}

enum WordCount { words12, words15, words18, words21, words24 }

class FfiConverterWordCount {
  static LiftRetVal<WordCount> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(WordCount.words12, 4);
      case 2:
        return LiftRetVal(WordCount.words15, 4);
      case 3:
        return LiftRetVal(WordCount.words18, 4);
      case 4:
        return LiftRetVal(WordCount.words21, 4);
      case 5:
        return LiftRetVal(WordCount.words24, 4);
      default:
        throw UniffiInternalError(
          UniffiInternalError.unexpectedEnumCase,
          "Unable to determine enum variant",
        );
    }
  }

  static WordCount lift(RustBuffer buffer) {
    return FfiConverterWordCount.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(WordCount input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(WordCount _value) {
    return 4;
  }

  static int write(WordCount value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

abstract class AddressInterface {
  bool isValidForNetwork(Network network);
  Script scriptPubkey();
  AddressData toAddressData();
  String toQrUri();
}

final _AddressFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_address(ptr, status));
});

class Address implements AddressInterface {
  late final Pointer<Void> _ptr;
  Address._(this._ptr) {
    _AddressFinalizer.attach(this, _ptr, detach: this);
  }
  Address.fromScript(Script script, Network network)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_address_from_script(
          Script.lower(script),
          FfiConverterNetwork.lower(network),
          status,
        ),
        fromScriptExceptionErrorHandler,
      ) {
    _AddressFinalizer.attach(this, _ptr, detach: this);
  }
  Address(String address, Network network)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_address_new(
          FfiConverterString.lower(address),
          FfiConverterNetwork.lower(network),
          status,
        ),
        addressParseExceptionErrorHandler,
      ) {
    _AddressFinalizer.attach(this, _ptr, detach: this);
  }
  factory Address.lift(Pointer<Void> ptr) {
    return Address._(ptr);
  }
  static Pointer<Void> lower(Address value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_address(_ptr, status));
  }

  static int allocationSize(Address value) {
    return 8;
  }

  static LiftRetVal<Address> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Address.lift(pointer), 8);
  }

  static int write(Address value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _AddressFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_address(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_address_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Address) {
      return false;
    }
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_address_uniffi_trait_eq_eq(
        uniffiClonePointer(),
        Address.lower(other),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  bool isValidForNetwork(Network network) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_address_is_valid_for_network(
        uniffiClonePointer(),
        FfiConverterNetwork.lower(network),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  Script scriptPubkey() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_address_script_pubkey(
        uniffiClonePointer(),
        status,
      ),
      Script.lift,
      null,
    );
  }

  AddressData toAddressData() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_address_to_address_data(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterAddressData.lift,
      null,
    );
  }

  String toQrUri() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_address_to_qr_uri(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }
}

abstract class AmountInterface {
  double toBtc();
  int toSat();
}

final _AmountFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_amount(ptr, status));
});

class Amount implements AmountInterface {
  late final Pointer<Void> _ptr;
  Amount._(this._ptr) {
    _AmountFinalizer.attach(this, _ptr, detach: this);
  }
  Amount.fromBtc(double btc)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_amount_from_btc(btc, status),
        parseAmountExceptionErrorHandler,
      ) {
    _AmountFinalizer.attach(this, _ptr, detach: this);
  }
  Amount.fromSat(int satoshi)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_amount_from_sat(
          FfiConverterUInt64.lower(satoshi),
          status,
        ),
        null,
      ) {
    _AmountFinalizer.attach(this, _ptr, detach: this);
  }
  factory Amount.lift(Pointer<Void> ptr) {
    return Amount._(ptr);
  }
  static Pointer<Void> lower(Amount value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_amount(_ptr, status));
  }

  static int allocationSize(Amount value) {
    return 8;
  }

  static LiftRetVal<Amount> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Amount.lift(pointer), 8);
  }

  static int write(Amount value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _AmountFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_amount(_ptr, status));
  }

  double toBtc() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_amount_to_btc(uniffiClonePointer(), status),
      FfiConverterDouble64.lift,
      null,
    );
  }

  int toSat() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_amount_to_sat(uniffiClonePointer(), status),
      FfiConverterUInt64.lift,
      null,
    );
  }
}

abstract class BlockHashInterface {
  Uint8List serialize();
}

final _BlockHashFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_blockhash(ptr, status));
});

class BlockHash implements BlockHashInterface {
  late final Pointer<Void> _ptr;
  BlockHash._(this._ptr) {
    _BlockHashFinalizer.attach(this, _ptr, detach: this);
  }
  BlockHash.fromBytes(Uint8List bytes)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_blockhash_from_bytes(
          FfiConverterUint8List.lower(bytes),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _BlockHashFinalizer.attach(this, _ptr, detach: this);
  }
  BlockHash.fromString(String hex)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_blockhash_from_string(
          FfiConverterString.lower(hex),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _BlockHashFinalizer.attach(this, _ptr, detach: this);
  }
  factory BlockHash.lift(Pointer<Void> ptr) {
    return BlockHash._(ptr);
  }
  static Pointer<Void> lower(BlockHash value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_blockhash(_ptr, status),
    );
  }

  static int allocationSize(BlockHash value) {
    return 8;
  }

  static LiftRetVal<BlockHash> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(BlockHash.lift(pointer), 8);
  }

  static int write(BlockHash value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _BlockHashFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_blockhash(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_blockhash_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! BlockHash) {
      return false;
    }
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_blockhash_uniffi_trait_eq_eq(
        uniffiClonePointer(),
        BlockHash.lower(other),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  @override
  int get hashCode {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_blockhash_uniffi_trait_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  Uint8List serialize() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_blockhash_serialize(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUint8List.lift,
      null,
    );
  }
}

abstract class BumpFeeTxBuilderInterface {
  BumpFeeTxBuilder allowDust(bool allowDust);
  BumpFeeTxBuilder currentHeight(int height);
  Psbt finish(Wallet wallet);
  BumpFeeTxBuilder nlocktime(LockTime locktime);
  BumpFeeTxBuilder setExactSequence(int nsequence);
  BumpFeeTxBuilder version(int version);
}

final _BumpFeeTxBuilderFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_bumpfeetxbuilder(ptr, status));
});

class BumpFeeTxBuilder implements BumpFeeTxBuilderInterface {
  late final Pointer<Void> _ptr;
  BumpFeeTxBuilder._(this._ptr) {
    _BumpFeeTxBuilderFinalizer.attach(this, _ptr, detach: this);
  }
  BumpFeeTxBuilder(Txid txid, FeeRate feeRate)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_bumpfeetxbuilder_new(
          Txid.lower(txid),
          FeeRate.lower(feeRate),
          status,
        ),
        null,
      ) {
    _BumpFeeTxBuilderFinalizer.attach(this, _ptr, detach: this);
  }
  factory BumpFeeTxBuilder.lift(Pointer<Void> ptr) {
    return BumpFeeTxBuilder._(ptr);
  }
  static Pointer<Void> lower(BumpFeeTxBuilder value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_bumpfeetxbuilder(_ptr, status),
    );
  }

  static int allocationSize(BumpFeeTxBuilder value) {
    return 8;
  }

  static LiftRetVal<BumpFeeTxBuilder> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(BumpFeeTxBuilder.lift(pointer), 8);
  }

  static int write(BumpFeeTxBuilder value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _BumpFeeTxBuilderFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_bumpfeetxbuilder(_ptr, status));
  }

  BumpFeeTxBuilder allowDust(bool allowDust) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_allow_dust(
        uniffiClonePointer(),
        FfiConverterBool.lower(allowDust),
        status,
      ),
      BumpFeeTxBuilder.lift,
      null,
    );
  }

  BumpFeeTxBuilder currentHeight(int height) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_current_height(
        uniffiClonePointer(),
        FfiConverterUInt32.lower(height),
        status,
      ),
      BumpFeeTxBuilder.lift,
      null,
    );
  }

  Psbt finish(Wallet wallet) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_finish(
        uniffiClonePointer(),
        Wallet.lower(wallet),
        status,
      ),
      Psbt.lift,
      createTxExceptionErrorHandler,
    );
  }

  BumpFeeTxBuilder nlocktime(LockTime locktime) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_nlocktime(
        uniffiClonePointer(),
        FfiConverterLockTime.lower(locktime),
        status,
      ),
      BumpFeeTxBuilder.lift,
      null,
    );
  }

  BumpFeeTxBuilder setExactSequence(int nsequence) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_set_exact_sequence(
        uniffiClonePointer(),
        FfiConverterUInt32.lower(nsequence),
        status,
      ),
      BumpFeeTxBuilder.lift,
      null,
    );
  }

  BumpFeeTxBuilder version(int version) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_version(
        uniffiClonePointer(),
        FfiConverterInt32.lower(version),
        status,
      ),
      BumpFeeTxBuilder.lift,
      null,
    );
  }
}

abstract class CbfBuilderInterface {
  CbfComponents build(Wallet wallet);
  CbfBuilder configureTimeoutMillis(int handshake, int response);
  CbfBuilder connections(int connections);
  CbfBuilder dataDir(String dataDir);
  CbfBuilder peers(List<Peer> peers);
  CbfBuilder scanType(ScanType scanType);
  CbfBuilder socks5Proxy(Socks5Proxy proxy);
}

final _CbfBuilderFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_cbfbuilder(ptr, status));
});

class CbfBuilder implements CbfBuilderInterface {
  late final Pointer<Void> _ptr;
  CbfBuilder._(this._ptr) {
    _CbfBuilderFinalizer.attach(this, _ptr, detach: this);
  }
  CbfBuilder()
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_cbfbuilder_new(status),
        null,
      ) {
    _CbfBuilderFinalizer.attach(this, _ptr, detach: this);
  }
  factory CbfBuilder.lift(Pointer<Void> ptr) {
    return CbfBuilder._(ptr);
  }
  static Pointer<Void> lower(CbfBuilder value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_cbfbuilder(_ptr, status),
    );
  }

  static int allocationSize(CbfBuilder value) {
    return 8;
  }

  static LiftRetVal<CbfBuilder> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(CbfBuilder.lift(pointer), 8);
  }

  static int write(CbfBuilder value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _CbfBuilderFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_cbfbuilder(_ptr, status));
  }

  CbfComponents build(Wallet wallet) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfbuilder_build(
        uniffiClonePointer(),
        Wallet.lower(wallet),
        status,
      ),
      FfiConverterCbfComponents.lift,
      null,
    );
  }

  CbfBuilder configureTimeoutMillis(int handshake, int response) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfbuilder_configure_timeout_millis(
        uniffiClonePointer(),
        FfiConverterUInt64.lower(handshake),
        FfiConverterUInt64.lower(response),
        status,
      ),
      CbfBuilder.lift,
      null,
    );
  }

  CbfBuilder connections(int connections) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfbuilder_connections(
        uniffiClonePointer(),
        FfiConverterUInt8.lower(connections),
        status,
      ),
      CbfBuilder.lift,
      null,
    );
  }

  CbfBuilder dataDir(String dataDir) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfbuilder_data_dir(
        uniffiClonePointer(),
        FfiConverterString.lower(dataDir),
        status,
      ),
      CbfBuilder.lift,
      null,
    );
  }

  CbfBuilder peers(List<Peer> peers) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfbuilder_peers(
        uniffiClonePointer(),
        FfiConverterSequencePeer.lower(peers),
        status,
      ),
      CbfBuilder.lift,
      null,
    );
  }

  CbfBuilder scanType(ScanType scanType) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfbuilder_scan_type(
        uniffiClonePointer(),
        FfiConverterScanType.lower(scanType),
        status,
      ),
      CbfBuilder.lift,
      null,
    );
  }

  CbfBuilder socks5Proxy(Socks5Proxy proxy) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfbuilder_socks5_proxy(
        uniffiClonePointer(),
        FfiConverterSocks5Proxy.lower(proxy),
        status,
      ),
      CbfBuilder.lift,
      null,
    );
  }
}

abstract class CbfClientInterface {
  Future<FeeRate> averageFeeRate(BlockHash blockhash);
  Future<Wtxid> broadcast(Transaction transaction);
  void connect(Peer peer);
  bool isRunning();
  List<IpAddress> lookupHost(String hostname);
  Future<FeeRate> minBroadcastFeerate();
  Future<Info> nextInfo();
  Future<Warning> nextWarning();
  void shutdown();
  Future<Update> update();
}

final _CbfClientFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_cbfclient(ptr, status));
});

class CbfClient implements CbfClientInterface {
  late final Pointer<Void> _ptr;
  CbfClient._(this._ptr) {
    _CbfClientFinalizer.attach(this, _ptr, detach: this);
  }
  factory CbfClient.lift(Pointer<Void> ptr) {
    return CbfClient._(ptr);
  }
  static Pointer<Void> lower(CbfClient value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_cbfclient(_ptr, status),
    );
  }

  static int allocationSize(CbfClient value) {
    return 8;
  }

  static LiftRetVal<CbfClient> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(CbfClient.lift(pointer), 8);
  }

  static int write(CbfClient value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _CbfClientFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_cbfclient(_ptr, status));
  }

  Future<FeeRate> averageFeeRate(BlockHash blockhash) {
    return uniffiRustCallAsync(
      () => uniffi_bdk_ffi_fn_method_cbfclient_average_fee_rate(
        uniffiClonePointer(),
        BlockHash.lower(blockhash),
      ),
      ffi_bdk_ffi_rust_future_poll_u64,
      ffi_bdk_ffi_rust_future_complete_u64,
      ffi_bdk_ffi_rust_future_free_u64,
      (ptr) => FeeRate.lift(Pointer<Void>.fromAddress(ptr)),
      cbfExceptionErrorHandler,
    );
  }

  Future<Wtxid> broadcast(Transaction transaction) {
    return uniffiRustCallAsync(
      () => uniffi_bdk_ffi_fn_method_cbfclient_broadcast(
        uniffiClonePointer(),
        Transaction.lower(transaction),
      ),
      ffi_bdk_ffi_rust_future_poll_u64,
      ffi_bdk_ffi_rust_future_complete_u64,
      ffi_bdk_ffi_rust_future_free_u64,
      (ptr) => Wtxid.lift(Pointer<Void>.fromAddress(ptr)),
      cbfExceptionErrorHandler,
    );
  }

  void connect(Peer peer) {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_cbfclient_connect(
        uniffiClonePointer(),
        FfiConverterPeer.lower(peer),
        status,
      );
    }, cbfExceptionErrorHandler);
  }

  bool isRunning() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfclient_is_running(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  List<IpAddress> lookupHost(String hostname) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_cbfclient_lookup_host(
        uniffiClonePointer(),
        FfiConverterString.lower(hostname),
        status,
      ),
      FfiConverterSequenceIpAddress.lift,
      null,
    );
  }

  Future<FeeRate> minBroadcastFeerate() {
    return uniffiRustCallAsync(
      () => uniffi_bdk_ffi_fn_method_cbfclient_min_broadcast_feerate(
        uniffiClonePointer(),
      ),
      ffi_bdk_ffi_rust_future_poll_u64,
      ffi_bdk_ffi_rust_future_complete_u64,
      ffi_bdk_ffi_rust_future_free_u64,
      (ptr) => FeeRate.lift(Pointer<Void>.fromAddress(ptr)),
      cbfExceptionErrorHandler,
    );
  }

  Future<Info> nextInfo() {
    return uniffiRustCallAsync(
      () => uniffi_bdk_ffi_fn_method_cbfclient_next_info(uniffiClonePointer()),
      ffi_bdk_ffi_rust_future_poll_rust_buffer,
      ffi_bdk_ffi_rust_future_complete_rust_buffer,
      ffi_bdk_ffi_rust_future_free_rust_buffer,
      FfiConverterInfo.lift,
      cbfExceptionErrorHandler,
    );
  }

  Future<Warning> nextWarning() {
    return uniffiRustCallAsync(
      () =>
          uniffi_bdk_ffi_fn_method_cbfclient_next_warning(uniffiClonePointer()),
      ffi_bdk_ffi_rust_future_poll_rust_buffer,
      ffi_bdk_ffi_rust_future_complete_rust_buffer,
      ffi_bdk_ffi_rust_future_free_rust_buffer,
      FfiConverterWarning.lift,
      cbfExceptionErrorHandler,
    );
  }

  void shutdown() {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_cbfclient_shutdown(uniffiClonePointer(), status);
    }, cbfExceptionErrorHandler);
  }

  Future<Update> update() {
    return uniffiRustCallAsync(
      () => uniffi_bdk_ffi_fn_method_cbfclient_update(uniffiClonePointer()),
      ffi_bdk_ffi_rust_future_poll_u64,
      ffi_bdk_ffi_rust_future_complete_u64,
      ffi_bdk_ffi_rust_future_free_u64,
      (ptr) => Update.lift(Pointer<Void>.fromAddress(ptr)),
      cbfExceptionErrorHandler,
    );
  }
}

abstract class CbfNodeInterface {
  void run();
}

final _CbfNodeFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_cbfnode(ptr, status));
});

class CbfNode implements CbfNodeInterface {
  late final Pointer<Void> _ptr;
  CbfNode._(this._ptr) {
    _CbfNodeFinalizer.attach(this, _ptr, detach: this);
  }
  factory CbfNode.lift(Pointer<Void> ptr) {
    return CbfNode._(ptr);
  }
  static Pointer<Void> lower(CbfNode value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_cbfnode(_ptr, status));
  }

  static int allocationSize(CbfNode value) {
    return 8;
  }

  static LiftRetVal<CbfNode> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(CbfNode.lift(pointer), 8);
  }

  static int write(CbfNode value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _CbfNodeFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_cbfnode(_ptr, status));
  }

  void run() {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_cbfnode_run(uniffiClonePointer(), status);
    }, null);
  }
}

abstract class ChangeSetInterface {
  Descriptor? changeDescriptor();
  Descriptor? descriptor();
  IndexerChangeSet indexerChangeset();
  LocalChainChangeSet localchainChangeset();
  Network? network();
  TxGraphChangeSet txGraphChangeset();
}

final _ChangeSetFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_changeset(ptr, status));
});

class ChangeSet implements ChangeSetInterface {
  late final Pointer<Void> _ptr;
  ChangeSet._(this._ptr) {
    _ChangeSetFinalizer.attach(this, _ptr, detach: this);
  }
  ChangeSet.fromAggregate(
    Descriptor? descriptor,
    Descriptor? changeDescriptor,
    Network? network,
    LocalChainChangeSet localChain,
    TxGraphChangeSet txGraph,
    IndexerChangeSet indexer,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_changeset_from_aggregate(
          FfiConverterOptionalDescriptor.lower(descriptor),
          FfiConverterOptionalDescriptor.lower(changeDescriptor),
          FfiConverterOptionalNetwork.lower(network),
          FfiConverterLocalChainChangeSet.lower(localChain),
          FfiConverterTxGraphChangeSet.lower(txGraph),
          FfiConverterIndexerChangeSet.lower(indexer),
          status,
        ),
        null,
      ) {
    _ChangeSetFinalizer.attach(this, _ptr, detach: this);
  }
  ChangeSet.fromDescriptorAndNetwork(
    Descriptor? descriptor,
    Descriptor? changeDescriptor,
    Network? network,
  ) : _ptr = rustCall(
        (status) =>
            uniffi_bdk_ffi_fn_constructor_changeset_from_descriptor_and_network(
              FfiConverterOptionalDescriptor.lower(descriptor),
              FfiConverterOptionalDescriptor.lower(changeDescriptor),
              FfiConverterOptionalNetwork.lower(network),
              status,
            ),
        null,
      ) {
    _ChangeSetFinalizer.attach(this, _ptr, detach: this);
  }
  ChangeSet.fromIndexerChangeset(IndexerChangeSet indexerChanges)
    : _ptr = rustCall(
        (status) =>
            uniffi_bdk_ffi_fn_constructor_changeset_from_indexer_changeset(
              FfiConverterIndexerChangeSet.lower(indexerChanges),
              status,
            ),
        null,
      ) {
    _ChangeSetFinalizer.attach(this, _ptr, detach: this);
  }
  ChangeSet.fromLocalChainChanges(LocalChainChangeSet localChainChanges)
    : _ptr = rustCall(
        (status) =>
            uniffi_bdk_ffi_fn_constructor_changeset_from_local_chain_changes(
              FfiConverterLocalChainChangeSet.lower(localChainChanges),
              status,
            ),
        null,
      ) {
    _ChangeSetFinalizer.attach(this, _ptr, detach: this);
  }
  ChangeSet.fromMerge(ChangeSet left, ChangeSet right)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_changeset_from_merge(
          ChangeSet.lower(left),
          ChangeSet.lower(right),
          status,
        ),
        null,
      ) {
    _ChangeSetFinalizer.attach(this, _ptr, detach: this);
  }
  ChangeSet.fromTxGraphChangeset(TxGraphChangeSet txGraphChangeset)
    : _ptr = rustCall(
        (status) =>
            uniffi_bdk_ffi_fn_constructor_changeset_from_tx_graph_changeset(
              FfiConverterTxGraphChangeSet.lower(txGraphChangeset),
              status,
            ),
        null,
      ) {
    _ChangeSetFinalizer.attach(this, _ptr, detach: this);
  }
  ChangeSet()
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_changeset_new(status),
        null,
      ) {
    _ChangeSetFinalizer.attach(this, _ptr, detach: this);
  }
  factory ChangeSet.lift(Pointer<Void> ptr) {
    return ChangeSet._(ptr);
  }
  static Pointer<Void> lower(ChangeSet value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_changeset(_ptr, status),
    );
  }

  static int allocationSize(ChangeSet value) {
    return 8;
  }

  static LiftRetVal<ChangeSet> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(ChangeSet.lift(pointer), 8);
  }

  static int write(ChangeSet value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _ChangeSetFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_changeset(_ptr, status));
  }

  Descriptor? changeDescriptor() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_changeset_change_descriptor(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterOptionalDescriptor.lift,
      null,
    );
  }

  Descriptor? descriptor() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_changeset_descriptor(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterOptionalDescriptor.lift,
      null,
    );
  }

  IndexerChangeSet indexerChangeset() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_changeset_indexer_changeset(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterIndexerChangeSet.lift,
      null,
    );
  }

  LocalChainChangeSet localchainChangeset() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_changeset_localchain_changeset(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterLocalChainChangeSet.lift,
      null,
    );
  }

  Network? network() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_changeset_network(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterOptionalNetwork.lift,
      null,
    );
  }

  TxGraphChangeSet txGraphChangeset() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_changeset_tx_graph_changeset(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterTxGraphChangeSet.lift,
      null,
    );
  }
}

abstract class DerivationPathInterface {
  bool isEmpty();
  bool isMaster();
  int len();
}

final _DerivationPathFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_derivationpath(ptr, status));
});

class DerivationPath implements DerivationPathInterface {
  late final Pointer<Void> _ptr;
  DerivationPath._(this._ptr) {
    _DerivationPathFinalizer.attach(this, _ptr, detach: this);
  }
  DerivationPath.master()
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_derivationpath_master(status),
        null,
      ) {
    _DerivationPathFinalizer.attach(this, _ptr, detach: this);
  }
  DerivationPath(String path)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_derivationpath_new(
          FfiConverterString.lower(path),
          status,
        ),
        bip32ExceptionErrorHandler,
      ) {
    _DerivationPathFinalizer.attach(this, _ptr, detach: this);
  }
  factory DerivationPath.lift(Pointer<Void> ptr) {
    return DerivationPath._(ptr);
  }
  static Pointer<Void> lower(DerivationPath value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_derivationpath(_ptr, status),
    );
  }

  static int allocationSize(DerivationPath value) {
    return 8;
  }

  static LiftRetVal<DerivationPath> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(DerivationPath.lift(pointer), 8);
  }

  static int write(DerivationPath value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _DerivationPathFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_derivationpath(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_derivationpath_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  bool isEmpty() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_derivationpath_is_empty(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  bool isMaster() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_derivationpath_is_master(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  int len() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_derivationpath_len(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }
}

abstract class DescriptorInterface {
  DescriptorType descType();
  DescriptorId descriptorId();
  bool isMultipath();
  int maxWeightToSatisfy();
  List<Descriptor> toSingleDescriptors();
  String toStringWithSecret();
}

final _DescriptorFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_descriptor(ptr, status));
});

class Descriptor implements DescriptorInterface {
  late final Pointer<Void> _ptr;
  Descriptor._(this._ptr) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor(String descriptor, Network network)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new(
          FfiConverterString.lower(descriptor),
          FfiConverterNetwork.lower(network),
          status,
        ),
        descriptorExceptionErrorHandler,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor.newBip44(
    DescriptorSecretKey secretKey,
    KeychainKind keychainKind,
    Network network,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new_bip44(
          DescriptorSecretKey.lower(secretKey),
          FfiConverterKeychainKind.lower(keychainKind),
          FfiConverterNetwork.lower(network),
          status,
        ),
        null,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor.newBip44Public(
    DescriptorPublicKey publicKey,
    String fingerprint,
    KeychainKind keychainKind,
    Network network,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new_bip44_public(
          DescriptorPublicKey.lower(publicKey),
          FfiConverterString.lower(fingerprint),
          FfiConverterKeychainKind.lower(keychainKind),
          FfiConverterNetwork.lower(network),
          status,
        ),
        descriptorExceptionErrorHandler,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor.newBip49(
    DescriptorSecretKey secretKey,
    KeychainKind keychainKind,
    Network network,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new_bip49(
          DescriptorSecretKey.lower(secretKey),
          FfiConverterKeychainKind.lower(keychainKind),
          FfiConverterNetwork.lower(network),
          status,
        ),
        null,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor.newBip49Public(
    DescriptorPublicKey publicKey,
    String fingerprint,
    KeychainKind keychainKind,
    Network network,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new_bip49_public(
          DescriptorPublicKey.lower(publicKey),
          FfiConverterString.lower(fingerprint),
          FfiConverterKeychainKind.lower(keychainKind),
          FfiConverterNetwork.lower(network),
          status,
        ),
        descriptorExceptionErrorHandler,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor.newBip84(
    DescriptorSecretKey secretKey,
    KeychainKind keychainKind,
    Network network,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new_bip84(
          DescriptorSecretKey.lower(secretKey),
          FfiConverterKeychainKind.lower(keychainKind),
          FfiConverterNetwork.lower(network),
          status,
        ),
        null,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor.newBip84Public(
    DescriptorPublicKey publicKey,
    String fingerprint,
    KeychainKind keychainKind,
    Network network,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new_bip84_public(
          DescriptorPublicKey.lower(publicKey),
          FfiConverterString.lower(fingerprint),
          FfiConverterKeychainKind.lower(keychainKind),
          FfiConverterNetwork.lower(network),
          status,
        ),
        descriptorExceptionErrorHandler,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor.newBip86(
    DescriptorSecretKey secretKey,
    KeychainKind keychainKind,
    Network network,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new_bip86(
          DescriptorSecretKey.lower(secretKey),
          FfiConverterKeychainKind.lower(keychainKind),
          FfiConverterNetwork.lower(network),
          status,
        ),
        null,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  Descriptor.newBip86Public(
    DescriptorPublicKey publicKey,
    String fingerprint,
    KeychainKind keychainKind,
    Network network,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptor_new_bip86_public(
          DescriptorPublicKey.lower(publicKey),
          FfiConverterString.lower(fingerprint),
          FfiConverterKeychainKind.lower(keychainKind),
          FfiConverterNetwork.lower(network),
          status,
        ),
        descriptorExceptionErrorHandler,
      ) {
    _DescriptorFinalizer.attach(this, _ptr, detach: this);
  }
  factory Descriptor.lift(Pointer<Void> ptr) {
    return Descriptor._(ptr);
  }
  static Pointer<Void> lower(Descriptor value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_descriptor(_ptr, status),
    );
  }

  static int allocationSize(Descriptor value) {
    return 8;
  }

  static LiftRetVal<Descriptor> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Descriptor.lift(pointer), 8);
  }

  static int write(Descriptor value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _DescriptorFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_descriptor(_ptr, status));
  }

  String debugString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptor_uniffi_trait_debug(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptor_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  DescriptorType descType() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptor_desc_type(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterDescriptorType.lift,
      null,
    );
  }

  DescriptorId descriptorId() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptor_descriptor_id(
        uniffiClonePointer(),
        status,
      ),
      DescriptorId.lift,
      null,
    );
  }

  bool isMultipath() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptor_is_multipath(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  int maxWeightToSatisfy() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptor_max_weight_to_satisfy(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      descriptorExceptionErrorHandler,
    );
  }

  List<Descriptor> toSingleDescriptors() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptor_to_single_descriptors(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSequenceDescriptor.lift,
      miniscriptExceptionErrorHandler,
    );
  }

  String toStringWithSecret() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptor_to_string_with_secret(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }
}

abstract class DescriptorIdInterface {
  Uint8List serialize();
}

final _DescriptorIdFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_descriptorid(ptr, status));
});

class DescriptorId implements DescriptorIdInterface {
  late final Pointer<Void> _ptr;
  DescriptorId._(this._ptr) {
    _DescriptorIdFinalizer.attach(this, _ptr, detach: this);
  }
  DescriptorId.fromBytes(Uint8List bytes)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptorid_from_bytes(
          FfiConverterUint8List.lower(bytes),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _DescriptorIdFinalizer.attach(this, _ptr, detach: this);
  }
  DescriptorId.fromString(String hex)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptorid_from_string(
          FfiConverterString.lower(hex),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _DescriptorIdFinalizer.attach(this, _ptr, detach: this);
  }
  factory DescriptorId.lift(Pointer<Void> ptr) {
    return DescriptorId._(ptr);
  }
  static Pointer<Void> lower(DescriptorId value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_descriptorid(_ptr, status),
    );
  }

  static int allocationSize(DescriptorId value) {
    return 8;
  }

  static LiftRetVal<DescriptorId> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(DescriptorId.lift(pointer), 8);
  }

  static int write(DescriptorId value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _DescriptorIdFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_descriptorid(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorid_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! DescriptorId) {
      return false;
    }
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorid_uniffi_trait_eq_eq(
        uniffiClonePointer(),
        DescriptorId.lower(other),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  @override
  int get hashCode {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorid_uniffi_trait_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  Uint8List serialize() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorid_serialize(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUint8List.lift,
      null,
    );
  }
}

abstract class DescriptorPublicKeyInterface {
  DescriptorPublicKey derive(DerivationPath path);
  DescriptorPublicKey extend(DerivationPath path);
  bool isMultipath();
  String masterFingerprint();
}

final _DescriptorPublicKeyFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_descriptorpublickey(ptr, status));
});

class DescriptorPublicKey implements DescriptorPublicKeyInterface {
  late final Pointer<Void> _ptr;
  DescriptorPublicKey._(this._ptr) {
    _DescriptorPublicKeyFinalizer.attach(this, _ptr, detach: this);
  }
  DescriptorPublicKey.fromString(String publicKey)
    : _ptr = rustCall(
        (status) =>
            uniffi_bdk_ffi_fn_constructor_descriptorpublickey_from_string(
              FfiConverterString.lower(publicKey),
              status,
            ),
        descriptorKeyExceptionErrorHandler,
      ) {
    _DescriptorPublicKeyFinalizer.attach(this, _ptr, detach: this);
  }
  factory DescriptorPublicKey.lift(Pointer<Void> ptr) {
    return DescriptorPublicKey._(ptr);
  }
  static Pointer<Void> lower(DescriptorPublicKey value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_descriptorpublickey(_ptr, status),
    );
  }

  static int allocationSize(DescriptorPublicKey value) {
    return 8;
  }

  static LiftRetVal<DescriptorPublicKey> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(DescriptorPublicKey.lift(pointer), 8);
  }

  static int write(DescriptorPublicKey value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _DescriptorPublicKeyFinalizer.detach(this);
    rustCall(
      (status) => uniffi_bdk_ffi_fn_free_descriptorpublickey(_ptr, status),
    );
  }

  String debugString() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_descriptorpublickey_uniffi_trait_debug(
            uniffiClonePointer(),
            status,
          ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_descriptorpublickey_uniffi_trait_display(
            uniffiClonePointer(),
            status,
          ),
      FfiConverterString.lift,
      null,
    );
  }

  DescriptorPublicKey derive(DerivationPath path) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorpublickey_derive(
        uniffiClonePointer(),
        DerivationPath.lower(path),
        status,
      ),
      DescriptorPublicKey.lift,
      descriptorKeyExceptionErrorHandler,
    );
  }

  DescriptorPublicKey extend(DerivationPath path) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorpublickey_extend(
        uniffiClonePointer(),
        DerivationPath.lower(path),
        status,
      ),
      DescriptorPublicKey.lift,
      descriptorKeyExceptionErrorHandler,
    );
  }

  bool isMultipath() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorpublickey_is_multipath(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  String masterFingerprint() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_descriptorpublickey_master_fingerprint(
            uniffiClonePointer(),
            status,
          ),
      FfiConverterString.lift,
      null,
    );
  }
}

abstract class DescriptorSecretKeyInterface {
  DescriptorPublicKey asPublic();
  DescriptorSecretKey derive(DerivationPath path);
  DescriptorSecretKey extend(DerivationPath path);
  Uint8List secretBytes();
}

final _DescriptorSecretKeyFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_descriptorsecretkey(ptr, status));
});

class DescriptorSecretKey implements DescriptorSecretKeyInterface {
  late final Pointer<Void> _ptr;
  DescriptorSecretKey._(this._ptr) {
    _DescriptorSecretKeyFinalizer.attach(this, _ptr, detach: this);
  }
  DescriptorSecretKey.fromString(String privateKey)
    : _ptr = rustCall(
        (status) =>
            uniffi_bdk_ffi_fn_constructor_descriptorsecretkey_from_string(
              FfiConverterString.lower(privateKey),
              status,
            ),
        descriptorKeyExceptionErrorHandler,
      ) {
    _DescriptorSecretKeyFinalizer.attach(this, _ptr, detach: this);
  }
  DescriptorSecretKey(Network network, Mnemonic mnemonic, String? password)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_descriptorsecretkey_new(
          FfiConverterNetwork.lower(network),
          Mnemonic.lower(mnemonic),
          FfiConverterOptionalString.lower(password),
          status,
        ),
        null,
      ) {
    _DescriptorSecretKeyFinalizer.attach(this, _ptr, detach: this);
  }
  factory DescriptorSecretKey.lift(Pointer<Void> ptr) {
    return DescriptorSecretKey._(ptr);
  }
  static Pointer<Void> lower(DescriptorSecretKey value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_descriptorsecretkey(_ptr, status),
    );
  }

  static int allocationSize(DescriptorSecretKey value) {
    return 8;
  }

  static LiftRetVal<DescriptorSecretKey> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(DescriptorSecretKey.lift(pointer), 8);
  }

  static int write(DescriptorSecretKey value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _DescriptorSecretKeyFinalizer.detach(this);
    rustCall(
      (status) => uniffi_bdk_ffi_fn_free_descriptorsecretkey(_ptr, status),
    );
  }

  String debugString() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_descriptorsecretkey_uniffi_trait_debug(
            uniffiClonePointer(),
            status,
          ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_descriptorsecretkey_uniffi_trait_display(
            uniffiClonePointer(),
            status,
          ),
      FfiConverterString.lift,
      null,
    );
  }

  DescriptorPublicKey asPublic() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorsecretkey_as_public(
        uniffiClonePointer(),
        status,
      ),
      DescriptorPublicKey.lift,
      null,
    );
  }

  DescriptorSecretKey derive(DerivationPath path) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorsecretkey_derive(
        uniffiClonePointer(),
        DerivationPath.lower(path),
        status,
      ),
      DescriptorSecretKey.lift,
      descriptorKeyExceptionErrorHandler,
    );
  }

  DescriptorSecretKey extend(DerivationPath path) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorsecretkey_extend(
        uniffiClonePointer(),
        DerivationPath.lower(path),
        status,
      ),
      DescriptorSecretKey.lift,
      descriptorKeyExceptionErrorHandler,
    );
  }

  Uint8List secretBytes() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_descriptorsecretkey_secret_bytes(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUint8List.lift,
      null,
    );
  }
}

abstract class ElectrumClientInterface {
  HeaderNotification blockHeadersSubscribe();
  double estimateFee(int number);
  Update fullScan(
    FullScanRequest request,
    int stopGap,
    int batchSize,
    bool fetchPrevTxouts,
  );
  void ping();
  ServerFeaturesRes serverFeatures();
  Update sync_(SyncRequest request, int batchSize, bool fetchPrevTxouts);
  Txid transactionBroadcast(Transaction tx);
}

final _ElectrumClientFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_electrumclient(ptr, status));
});

class ElectrumClient implements ElectrumClientInterface {
  late final Pointer<Void> _ptr;
  ElectrumClient._(this._ptr) {
    _ElectrumClientFinalizer.attach(this, _ptr, detach: this);
  }
  ElectrumClient(String url, String? socks5)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_electrumclient_new(
          FfiConverterString.lower(url),
          FfiConverterOptionalString.lower(socks5),
          status,
        ),
        electrumExceptionErrorHandler,
      ) {
    _ElectrumClientFinalizer.attach(this, _ptr, detach: this);
  }
  factory ElectrumClient.lift(Pointer<Void> ptr) {
    return ElectrumClient._(ptr);
  }
  static Pointer<Void> lower(ElectrumClient value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_electrumclient(_ptr, status),
    );
  }

  static int allocationSize(ElectrumClient value) {
    return 8;
  }

  static LiftRetVal<ElectrumClient> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(ElectrumClient.lift(pointer), 8);
  }

  static int write(ElectrumClient value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _ElectrumClientFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_electrumclient(_ptr, status));
  }

  HeaderNotification blockHeadersSubscribe() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_electrumclient_block_headers_subscribe(
            uniffiClonePointer(),
            status,
          ),
      FfiConverterHeaderNotification.lift,
      electrumExceptionErrorHandler,
    );
  }

  double estimateFee(int number) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_electrumclient_estimate_fee(
        uniffiClonePointer(),
        FfiConverterUInt64.lower(number),
        status,
      ),
      FfiConverterDouble64.lift,
      electrumExceptionErrorHandler,
    );
  }

  Update fullScan(
    FullScanRequest request,
    int stopGap,
    int batchSize,
    bool fetchPrevTxouts,
  ) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_electrumclient_full_scan(
        uniffiClonePointer(),
        FullScanRequest.lower(request),
        FfiConverterUInt64.lower(stopGap),
        FfiConverterUInt64.lower(batchSize),
        FfiConverterBool.lower(fetchPrevTxouts),
        status,
      ),
      Update.lift,
      electrumExceptionErrorHandler,
    );
  }

  void ping() {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_electrumclient_ping(
        uniffiClonePointer(),
        status,
      );
    }, electrumExceptionErrorHandler);
  }

  ServerFeaturesRes serverFeatures() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_electrumclient_server_features(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterServerFeaturesRes.lift,
      electrumExceptionErrorHandler,
    );
  }

  Update sync_(SyncRequest request, int batchSize, bool fetchPrevTxouts) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_electrumclient_sync(
        uniffiClonePointer(),
        SyncRequest.lower(request),
        FfiConverterUInt64.lower(batchSize),
        FfiConverterBool.lower(fetchPrevTxouts),
        status,
      ),
      Update.lift,
      electrumExceptionErrorHandler,
    );
  }

  Txid transactionBroadcast(Transaction tx) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_electrumclient_transaction_broadcast(
        uniffiClonePointer(),
        Transaction.lower(tx),
        status,
      ),
      Txid.lift,
      electrumExceptionErrorHandler,
    );
  }
}

abstract class EsploraClientInterface {
  void broadcast(Transaction transaction);
  Update fullScan(FullScanRequest request, int stopGap, int parallelRequests);
  BlockHash getBlockHash(int blockHeight);
  Map<int, double> getFeeEstimates();
  int getHeight();
  Transaction? getTx(Txid txid);
  Tx? getTxInfo(Txid txid);
  TxStatus getTxStatus(Txid txid);
  Update sync_(SyncRequest request, int parallelRequests);
}

final _EsploraClientFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_esploraclient(ptr, status));
});

class EsploraClient implements EsploraClientInterface {
  late final Pointer<Void> _ptr;
  EsploraClient._(this._ptr) {
    _EsploraClientFinalizer.attach(this, _ptr, detach: this);
  }
  EsploraClient(String url, String? proxy)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_esploraclient_new(
          FfiConverterString.lower(url),
          FfiConverterOptionalString.lower(proxy),
          status,
        ),
        null,
      ) {
    _EsploraClientFinalizer.attach(this, _ptr, detach: this);
  }
  factory EsploraClient.lift(Pointer<Void> ptr) {
    return EsploraClient._(ptr);
  }
  static Pointer<Void> lower(EsploraClient value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_esploraclient(_ptr, status),
    );
  }

  static int allocationSize(EsploraClient value) {
    return 8;
  }

  static LiftRetVal<EsploraClient> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(EsploraClient.lift(pointer), 8);
  }

  static int write(EsploraClient value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _EsploraClientFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_esploraclient(_ptr, status));
  }

  void broadcast(Transaction transaction) {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_esploraclient_broadcast(
        uniffiClonePointer(),
        Transaction.lower(transaction),
        status,
      );
    }, esploraExceptionErrorHandler);
  }

  Update fullScan(FullScanRequest request, int stopGap, int parallelRequests) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_esploraclient_full_scan(
        uniffiClonePointer(),
        FullScanRequest.lower(request),
        FfiConverterUInt64.lower(stopGap),
        FfiConverterUInt64.lower(parallelRequests),
        status,
      ),
      Update.lift,
      esploraExceptionErrorHandler,
    );
  }

  BlockHash getBlockHash(int blockHeight) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_esploraclient_get_block_hash(
        uniffiClonePointer(),
        FfiConverterUInt32.lower(blockHeight),
        status,
      ),
      BlockHash.lift,
      esploraExceptionErrorHandler,
    );
  }

  Map<int, double> getFeeEstimates() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_esploraclient_get_fee_estimates(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterMapUInt16ToDouble64.lift,
      esploraExceptionErrorHandler,
    );
  }

  int getHeight() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_esploraclient_get_height(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt32.lift,
      esploraExceptionErrorHandler,
    );
  }

  Transaction? getTx(Txid txid) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_esploraclient_get_tx(
        uniffiClonePointer(),
        Txid.lower(txid),
        status,
      ),
      FfiConverterOptionalTransaction.lift,
      esploraExceptionErrorHandler,
    );
  }

  Tx? getTxInfo(Txid txid) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_esploraclient_get_tx_info(
        uniffiClonePointer(),
        Txid.lower(txid),
        status,
      ),
      FfiConverterOptionalTx.lift,
      esploraExceptionErrorHandler,
    );
  }

  TxStatus getTxStatus(Txid txid) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_esploraclient_get_tx_status(
        uniffiClonePointer(),
        Txid.lower(txid),
        status,
      ),
      FfiConverterTxStatus.lift,
      esploraExceptionErrorHandler,
    );
  }

  Update sync_(SyncRequest request, int parallelRequests) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_esploraclient_sync(
        uniffiClonePointer(),
        SyncRequest.lower(request),
        FfiConverterUInt64.lower(parallelRequests),
        status,
      ),
      Update.lift,
      esploraExceptionErrorHandler,
    );
  }
}

abstract class FeeRateInterface {
  Amount? feeVb(int vb);
  Amount? feeWu(int wu);
  int toSatPerKwu();
  int toSatPerVbCeil();
  int toSatPerVbFloor();
}

final _FeeRateFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_feerate(ptr, status));
});

class FeeRate implements FeeRateInterface {
  late final Pointer<Void> _ptr;
  FeeRate._(this._ptr) {
    _FeeRateFinalizer.attach(this, _ptr, detach: this);
  }
  FeeRate.fromSatPerKwu(int satKwu)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_feerate_from_sat_per_kwu(
          FfiConverterUInt64.lower(satKwu),
          status,
        ),
        null,
      ) {
    _FeeRateFinalizer.attach(this, _ptr, detach: this);
  }
  FeeRate.fromSatPerVb(int satVb)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_feerate_from_sat_per_vb(
          FfiConverterUInt64.lower(satVb),
          status,
        ),
        feeRateExceptionErrorHandler,
      ) {
    _FeeRateFinalizer.attach(this, _ptr, detach: this);
  }
  factory FeeRate.lift(Pointer<Void> ptr) {
    return FeeRate._(ptr);
  }
  static Pointer<Void> lower(FeeRate value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_feerate(_ptr, status));
  }

  static int allocationSize(FeeRate value) {
    return 8;
  }

  static LiftRetVal<FeeRate> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(FeeRate.lift(pointer), 8);
  }

  static int write(FeeRate value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _FeeRateFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_feerate(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_feerate_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  Amount? feeVb(int vb) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_feerate_fee_vb(
        uniffiClonePointer(),
        FfiConverterUInt64.lower(vb),
        status,
      ),
      FfiConverterOptionalAmount.lift,
      null,
    );
  }

  Amount? feeWu(int wu) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_feerate_fee_wu(
        uniffiClonePointer(),
        FfiConverterUInt64.lower(wu),
        status,
      ),
      FfiConverterOptionalAmount.lift,
      null,
    );
  }

  int toSatPerKwu() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_feerate_to_sat_per_kwu(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  int toSatPerVbCeil() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_feerate_to_sat_per_vb_ceil(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  int toSatPerVbFloor() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_feerate_to_sat_per_vb_floor(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }
}

abstract class FullScanRequestInterface {}

final _FullScanRequestFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_fullscanrequest(ptr, status));
});

class FullScanRequest implements FullScanRequestInterface {
  late final Pointer<Void> _ptr;
  FullScanRequest._(this._ptr) {
    _FullScanRequestFinalizer.attach(this, _ptr, detach: this);
  }
  factory FullScanRequest.lift(Pointer<Void> ptr) {
    return FullScanRequest._(ptr);
  }
  static Pointer<Void> lower(FullScanRequest value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_fullscanrequest(_ptr, status),
    );
  }

  static int allocationSize(FullScanRequest value) {
    return 8;
  }

  static LiftRetVal<FullScanRequest> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(FullScanRequest.lift(pointer), 8);
  }

  static int write(FullScanRequest value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _FullScanRequestFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_fullscanrequest(_ptr, status));
  }
}

abstract class FullScanRequestBuilderInterface {
  FullScanRequest build();
  FullScanRequestBuilder inspectSpksForAllKeychains(
    FullScanScriptInspector inspector,
  );
}

final _FullScanRequestBuilderFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall(
    (status) => uniffi_bdk_ffi_fn_free_fullscanrequestbuilder(ptr, status),
  );
});

class FullScanRequestBuilder implements FullScanRequestBuilderInterface {
  late final Pointer<Void> _ptr;
  FullScanRequestBuilder._(this._ptr) {
    _FullScanRequestBuilderFinalizer.attach(this, _ptr, detach: this);
  }
  factory FullScanRequestBuilder.lift(Pointer<Void> ptr) {
    return FullScanRequestBuilder._(ptr);
  }
  static Pointer<Void> lower(FullScanRequestBuilder value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_fullscanrequestbuilder(_ptr, status),
    );
  }

  static int allocationSize(FullScanRequestBuilder value) {
    return 8;
  }

  static LiftRetVal<FullScanRequestBuilder> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(FullScanRequestBuilder.lift(pointer), 8);
  }

  static int write(FullScanRequestBuilder value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _FullScanRequestBuilderFinalizer.detach(this);
    rustCall(
      (status) => uniffi_bdk_ffi_fn_free_fullscanrequestbuilder(_ptr, status),
    );
  }

  FullScanRequest build() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_fullscanrequestbuilder_build(
        uniffiClonePointer(),
        status,
      ),
      FullScanRequest.lift,
      requestBuilderExceptionErrorHandler,
    );
  }

  FullScanRequestBuilder inspectSpksForAllKeychains(
    FullScanScriptInspector inspector,
  ) {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_fullscanrequestbuilder_inspect_spks_for_all_keychains(
            uniffiClonePointer(),
            FfiConverterCallbackInterfaceFullScanScriptInspector.lower(
              inspector,
            ),
            status,
          ),
      FullScanRequestBuilder.lift,
      requestBuilderExceptionErrorHandler,
    );
  }
}

abstract class FullScanScriptInspector {
  void inspect(KeychainKind keychain, int index, Script script);
}

class FfiConverterCallbackInterfaceFullScanScriptInspector {
  static final _handleMap = UniffiHandleMap<FullScanScriptInspector>();
  static bool _vtableInitialized = false;
  static FullScanScriptInspector lift(Pointer<Void> handle) {
    return _handleMap.get(handle.address);
  }

  static Pointer<Void> lower(FullScanScriptInspector value) {
    _ensureVTableInitialized();
    final handle = _handleMap.insert(value);
    return Pointer<Void>.fromAddress(handle);
  }

  static void _ensureVTableInitialized() {
    if (!_vtableInitialized) {
      initFullScanScriptInspectorVTable();
      _vtableInitialized = true;
    }
  }

  static LiftRetVal<FullScanScriptInspector> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(lift(pointer), 8);
  }

  static int write(FullScanScriptInspector value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  static int allocationSize(FullScanScriptInspector value) {
    return 8;
  }
}

typedef UniffiCallbackInterfaceFullScanScriptInspectorMethod0 =
    Void Function(
      Uint64,
      Int32,
      Uint32,
      Pointer<Void>,
      Pointer<Void>,
      Pointer<RustCallStatus>,
    );
typedef UniffiCallbackInterfaceFullScanScriptInspectorMethod0Dart =
    void Function(
      int,
      int,
      int,
      Pointer<Void>,
      Pointer<Void>,
      Pointer<RustCallStatus>,
    );
typedef UniffiCallbackInterfaceFullScanScriptInspectorFree =
    Void Function(Uint64);
typedef UniffiCallbackInterfaceFullScanScriptInspectorFreeDart =
    void Function(int);
typedef UniffiCallbackInterfaceFullScanScriptInspectorClone =
    Uint64 Function(Uint64);
typedef UniffiCallbackInterfaceFullScanScriptInspectorCloneDart =
    int Function(int);

final class UniffiVTableCallbackInterfaceFullScanScriptInspector
    extends Struct {
  external Pointer<
    NativeFunction<UniffiCallbackInterfaceFullScanScriptInspectorFree>
  >
  uniffiFree;
  external Pointer<
    NativeFunction<UniffiCallbackInterfaceFullScanScriptInspectorClone>
  >
  uniffiClone;
  external Pointer<
    NativeFunction<UniffiCallbackInterfaceFullScanScriptInspectorMethod0>
  >
  inspect;
}

void fullScanScriptInspectorInspect(
  int uniffiHandle,
  int keychain,
  int index,
  Pointer<Void> script,
  Pointer<Void> outReturn,
  Pointer<RustCallStatus> callStatus,
) {
  final status = callStatus.ref;
  try {
    final obj = FfiConverterCallbackInterfaceFullScanScriptInspector._handleMap
        .get(uniffiHandle);
    final arg0 = FfiConverterKeychainKind.read(
      createUint8ListFromInt(keychain),
    ).value;
    final arg1 = FfiConverterUInt32.lift(index);
    final arg2 = Script.lift(script);
    obj.inspect(arg0, arg1, arg2);
    status.code = CALL_SUCCESS;
  } catch (e) {
    status.code = CALL_UNEXPECTED_ERROR;
    status.errorBuf = FfiConverterString.lower(e.toString());
  }
}

final Pointer<
  NativeFunction<UniffiCallbackInterfaceFullScanScriptInspectorMethod0>
>
fullScanScriptInspectorInspectPointer =
    Pointer.fromFunction<UniffiCallbackInterfaceFullScanScriptInspectorMethod0>(
      fullScanScriptInspectorInspect,
    );
void fullScanScriptInspectorFreeCallback(int handle) {
  try {
    FfiConverterCallbackInterfaceFullScanScriptInspector._handleMap.remove(
      handle,
    );
  } catch (e) {}
}

final Pointer<
  NativeFunction<UniffiCallbackInterfaceFullScanScriptInspectorFree>
>
fullScanScriptInspectorFreePointer =
    Pointer.fromFunction<UniffiCallbackInterfaceFullScanScriptInspectorFree>(
      fullScanScriptInspectorFreeCallback,
    );
int fullScanScriptInspectorCloneCallback(int handle) {
  try {
    final obj = FfiConverterCallbackInterfaceFullScanScriptInspector._handleMap
        .get(handle);
    final newHandle = FfiConverterCallbackInterfaceFullScanScriptInspector
        ._handleMap
        .insert(obj);
    return newHandle;
  } catch (e) {
    return 0;
  }
}

final Pointer<
  NativeFunction<UniffiCallbackInterfaceFullScanScriptInspectorClone>
>
fullScanScriptInspectorClonePointer =
    Pointer.fromFunction<UniffiCallbackInterfaceFullScanScriptInspectorClone>(
      fullScanScriptInspectorCloneCallback,
      0,
    );
late final Pointer<UniffiVTableCallbackInterfaceFullScanScriptInspector>
fullScanScriptInspectorVTable;
void initFullScanScriptInspectorVTable() {
  if (FfiConverterCallbackInterfaceFullScanScriptInspector._vtableInitialized) {
    return;
  }
  fullScanScriptInspectorVTable =
      calloc<UniffiVTableCallbackInterfaceFullScanScriptInspector>();
  fullScanScriptInspectorVTable.ref.uniffiFree =
      fullScanScriptInspectorFreePointer;
  fullScanScriptInspectorVTable.ref.uniffiClone =
      fullScanScriptInspectorClonePointer;
  fullScanScriptInspectorVTable.ref.inspect =
      fullScanScriptInspectorInspectPointer;
  rustCall((status) {
    uniffi_bdk_ffi_fn_init_callback_vtable_fullscanscriptinspector(
      fullScanScriptInspectorVTable,
    );
    checkCallStatus(NullRustCallStatusErrorHandler(), status);
  });
  FfiConverterCallbackInterfaceFullScanScriptInspector._vtableInitialized =
      true;
}

abstract class HashableOutPointInterface {
  OutPoint outpoint();
}

final _HashableOutPointFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_hashableoutpoint(ptr, status));
});

class HashableOutPoint implements HashableOutPointInterface {
  late final Pointer<Void> _ptr;
  HashableOutPoint._(this._ptr) {
    _HashableOutPointFinalizer.attach(this, _ptr, detach: this);
  }
  HashableOutPoint(OutPoint outpoint)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_hashableoutpoint_new(
          FfiConverterOutPoint.lower(outpoint),
          status,
        ),
        null,
      ) {
    _HashableOutPointFinalizer.attach(this, _ptr, detach: this);
  }
  factory HashableOutPoint.lift(Pointer<Void> ptr) {
    return HashableOutPoint._(ptr);
  }
  static Pointer<Void> lower(HashableOutPoint value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_hashableoutpoint(_ptr, status),
    );
  }

  static int allocationSize(HashableOutPoint value) {
    return 8;
  }

  static LiftRetVal<HashableOutPoint> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(HashableOutPoint.lift(pointer), 8);
  }

  static int write(HashableOutPoint value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _HashableOutPointFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_hashableoutpoint(_ptr, status));
  }

  String debugString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_hashableoutpoint_uniffi_trait_debug(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! HashableOutPoint) {
      return false;
    }
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_hashableoutpoint_uniffi_trait_eq_eq(
        uniffiClonePointer(),
        HashableOutPoint.lower(other),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  @override
  int get hashCode {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_hashableoutpoint_uniffi_trait_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  OutPoint outpoint() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_hashableoutpoint_outpoint(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterOutPoint.lift,
      null,
    );
  }
}

abstract class IpAddressInterface {}

final _IpAddressFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_ipaddress(ptr, status));
});

class IpAddress implements IpAddressInterface {
  late final Pointer<Void> _ptr;
  IpAddress._(this._ptr) {
    _IpAddressFinalizer.attach(this, _ptr, detach: this);
  }
  IpAddress.fromIpv4(int q1, int q2, int q3, int q4)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_ipaddress_from_ipv4(
          FfiConverterUInt8.lower(q1),
          FfiConverterUInt8.lower(q2),
          FfiConverterUInt8.lower(q3),
          FfiConverterUInt8.lower(q4),
          status,
        ),
        null,
      ) {
    _IpAddressFinalizer.attach(this, _ptr, detach: this);
  }
  IpAddress.fromIpv6(int a, int b, int c, int d, int e, int f, int g, int h)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_ipaddress_from_ipv6(
          FfiConverterUInt16.lower(a),
          FfiConverterUInt16.lower(b),
          FfiConverterUInt16.lower(c),
          FfiConverterUInt16.lower(d),
          FfiConverterUInt16.lower(e),
          FfiConverterUInt16.lower(f),
          FfiConverterUInt16.lower(g),
          FfiConverterUInt16.lower(h),
          status,
        ),
        null,
      ) {
    _IpAddressFinalizer.attach(this, _ptr, detach: this);
  }
  factory IpAddress.lift(Pointer<Void> ptr) {
    return IpAddress._(ptr);
  }
  static Pointer<Void> lower(IpAddress value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_ipaddress(_ptr, status),
    );
  }

  static int allocationSize(IpAddress value) {
    return 8;
  }

  static LiftRetVal<IpAddress> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(IpAddress.lift(pointer), 8);
  }

  static int write(IpAddress value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _IpAddressFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_ipaddress(_ptr, status));
  }
}

abstract class LeafNodeInterface {
  int depth();
  String? leafHash();
  int? leafVersion();
  List<String> merkleBranch();
  String nodeHash();
  Script? script();
}

final _LeafNodeFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_leafnode(ptr, status));
});

class LeafNode implements LeafNodeInterface {
  late final Pointer<Void> _ptr;
  LeafNode._(this._ptr) {
    _LeafNodeFinalizer.attach(this, _ptr, detach: this);
  }
  factory LeafNode.lift(Pointer<Void> ptr) {
    return LeafNode._(ptr);
  }
  static Pointer<Void> lower(LeafNode value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_leafnode(_ptr, status));
  }

  static int allocationSize(LeafNode value) {
    return 8;
  }

  static LiftRetVal<LeafNode> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(LeafNode.lift(pointer), 8);
  }

  static int write(LeafNode value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _LeafNodeFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_leafnode(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_leafnode_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  int depth() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_leafnode_depth(uniffiClonePointer(), status),
      FfiConverterUInt8.lift,
      null,
    );
  }

  String? leafHash() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_leafnode_leaf_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterOptionalString.lift,
      null,
    );
  }

  int? leafVersion() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_leafnode_leaf_version(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterOptionalUInt8.lift,
      null,
    );
  }

  List<String> merkleBranch() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_leafnode_merkle_branch(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSequenceString.lift,
      null,
    );
  }

  String nodeHash() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_leafnode_node_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  Script? script() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_leafnode_script(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterOptionalScript.lift,
      null,
    );
  }
}

abstract class MnemonicInterface {}

final _MnemonicFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_mnemonic(ptr, status));
});

class Mnemonic implements MnemonicInterface {
  late final Pointer<Void> _ptr;
  Mnemonic._(this._ptr) {
    _MnemonicFinalizer.attach(this, _ptr, detach: this);
  }
  Mnemonic.fromEntropy(Uint8List entropy)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_mnemonic_from_entropy(
          FfiConverterUint8List.lower(entropy),
          status,
        ),
        bip39ExceptionErrorHandler,
      ) {
    _MnemonicFinalizer.attach(this, _ptr, detach: this);
  }
  Mnemonic.fromString(String mnemonic)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_mnemonic_from_string(
          FfiConverterString.lower(mnemonic),
          status,
        ),
        bip39ExceptionErrorHandler,
      ) {
    _MnemonicFinalizer.attach(this, _ptr, detach: this);
  }
  Mnemonic(WordCount wordCount)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_mnemonic_new(
          FfiConverterWordCount.lower(wordCount),
          status,
        ),
        null,
      ) {
    _MnemonicFinalizer.attach(this, _ptr, detach: this);
  }
  factory Mnemonic.lift(Pointer<Void> ptr) {
    return Mnemonic._(ptr);
  }
  static Pointer<Void> lower(Mnemonic value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_mnemonic(_ptr, status));
  }

  static int allocationSize(Mnemonic value) {
    return 8;
  }

  static LiftRetVal<Mnemonic> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Mnemonic.lift(pointer), 8);
  }

  static int write(Mnemonic value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _MnemonicFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_mnemonic(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_mnemonic_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }
}

abstract class NodeInfoInterface {
  List<LeafNode> leafNodes();
  String nodeHash();
}

final _NodeInfoFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_nodeinfo(ptr, status));
});

class NodeInfo implements NodeInfoInterface {
  late final Pointer<Void> _ptr;
  NodeInfo._(this._ptr) {
    _NodeInfoFinalizer.attach(this, _ptr, detach: this);
  }
  factory NodeInfo.lift(Pointer<Void> ptr) {
    return NodeInfo._(ptr);
  }
  static Pointer<Void> lower(NodeInfo value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_nodeinfo(_ptr, status));
  }

  static int allocationSize(NodeInfo value) {
    return 8;
  }

  static LiftRetVal<NodeInfo> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(NodeInfo.lift(pointer), 8);
  }

  static int write(NodeInfo value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _NodeInfoFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_nodeinfo(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_nodeinfo_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  List<LeafNode> leafNodes() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_nodeinfo_leaf_nodes(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSequenceLeafNode.lift,
      null,
    );
  }

  String nodeHash() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_nodeinfo_node_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }
}

abstract class Persistence {
  ChangeSet initialize();
  void persist(ChangeSet changeset);
}

class FfiConverterCallbackInterfacePersistence {
  static final _handleMap = UniffiHandleMap<Persistence>();
  static bool _vtableInitialized = false;
  static Persistence lift(Pointer<Void> handle) {
    return _handleMap.get(handle.address);
  }

  static Pointer<Void> lower(Persistence value) {
    _ensureVTableInitialized();
    final handle = _handleMap.insert(value);
    return Pointer<Void>.fromAddress(handle);
  }

  static void _ensureVTableInitialized() {
    if (!_vtableInitialized) {
      initPersistenceVTable();
      _vtableInitialized = true;
    }
  }

  static LiftRetVal<Persistence> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(lift(pointer), 8);
  }

  static int write(Persistence value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  static int allocationSize(Persistence value) {
    return 8;
  }
}

typedef UniffiCallbackInterfacePersistenceMethod0 =
    Void Function(Uint64, Pointer<Pointer<Void>>, Pointer<RustCallStatus>);
typedef UniffiCallbackInterfacePersistenceMethod0Dart =
    void Function(int, Pointer<Pointer<Void>>, Pointer<RustCallStatus>);
typedef UniffiCallbackInterfacePersistenceMethod1 =
    Void Function(
      Uint64,
      Pointer<Void>,
      Pointer<Void>,
      Pointer<RustCallStatus>,
    );
typedef UniffiCallbackInterfacePersistenceMethod1Dart =
    void Function(int, Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>);
typedef UniffiCallbackInterfacePersistenceFree = Void Function(Uint64);
typedef UniffiCallbackInterfacePersistenceFreeDart = void Function(int);
typedef UniffiCallbackInterfacePersistenceClone = Uint64 Function(Uint64);
typedef UniffiCallbackInterfacePersistenceCloneDart = int Function(int);

final class UniffiVTableCallbackInterfacePersistence extends Struct {
  external Pointer<NativeFunction<UniffiCallbackInterfacePersistenceFree>>
  uniffiFree;
  external Pointer<NativeFunction<UniffiCallbackInterfacePersistenceClone>>
  uniffiClone;
  external Pointer<NativeFunction<UniffiCallbackInterfacePersistenceMethod0>>
  initialize;
  external Pointer<NativeFunction<UniffiCallbackInterfacePersistenceMethod1>>
  persist;
}

void persistenceInitialize(
  int uniffiHandle,
  Pointer<Pointer<Void>> outReturn,
  Pointer<RustCallStatus> callStatus,
) {
  final status = callStatus.ref;
  try {
    final obj = FfiConverterCallbackInterfacePersistence._handleMap.get(
      uniffiHandle,
    );
    final result = obj.initialize();
    outReturn.value = ChangeSet.lower(result);
  } catch (e) {
    status.code = CALL_UNEXPECTED_ERROR;
    status.errorBuf = FfiConverterString.lower(e.toString());
  }
}

final Pointer<NativeFunction<UniffiCallbackInterfacePersistenceMethod0>>
persistenceInitializePointer =
    Pointer.fromFunction<UniffiCallbackInterfacePersistenceMethod0>(
      persistenceInitialize,
    );
void persistencePersist(
  int uniffiHandle,
  Pointer<Void> changeset,
  Pointer<Void> outReturn,
  Pointer<RustCallStatus> callStatus,
) {
  final status = callStatus.ref;
  try {
    final obj = FfiConverterCallbackInterfacePersistence._handleMap.get(
      uniffiHandle,
    );
    final arg0 = ChangeSet.lift(changeset);
    obj.persist(arg0);
    status.code = CALL_SUCCESS;
  } catch (e) {
    status.code = CALL_UNEXPECTED_ERROR;
    status.errorBuf = FfiConverterString.lower(e.toString());
  }
}

final Pointer<NativeFunction<UniffiCallbackInterfacePersistenceMethod1>>
persistencePersistPointer =
    Pointer.fromFunction<UniffiCallbackInterfacePersistenceMethod1>(
      persistencePersist,
    );
void persistenceFreeCallback(int handle) {
  try {
    FfiConverterCallbackInterfacePersistence._handleMap.remove(handle);
  } catch (e) {}
}

final Pointer<NativeFunction<UniffiCallbackInterfacePersistenceFree>>
persistenceFreePointer =
    Pointer.fromFunction<UniffiCallbackInterfacePersistenceFree>(
      persistenceFreeCallback,
    );
int persistenceCloneCallback(int handle) {
  try {
    final obj = FfiConverterCallbackInterfacePersistence._handleMap.get(handle);
    final newHandle = FfiConverterCallbackInterfacePersistence._handleMap
        .insert(obj);
    return newHandle;
  } catch (e) {
    return 0;
  }
}

final Pointer<NativeFunction<UniffiCallbackInterfacePersistenceClone>>
persistenceClonePointer =
    Pointer.fromFunction<UniffiCallbackInterfacePersistenceClone>(
      persistenceCloneCallback,
      0,
    );
late final Pointer<UniffiVTableCallbackInterfacePersistence> persistenceVTable;
void initPersistenceVTable() {
  if (FfiConverterCallbackInterfacePersistence._vtableInitialized) {
    return;
  }
  persistenceVTable = calloc<UniffiVTableCallbackInterfacePersistence>();
  persistenceVTable.ref.uniffiFree = persistenceFreePointer;
  persistenceVTable.ref.uniffiClone = persistenceClonePointer;
  persistenceVTable.ref.initialize = persistenceInitializePointer;
  persistenceVTable.ref.persist = persistencePersistPointer;
  rustCall((status) {
    uniffi_bdk_ffi_fn_init_callback_vtable_persistence(persistenceVTable);
    checkCallStatus(NullRustCallStatusErrorHandler(), status);
  });
  FfiConverterCallbackInterfacePersistence._vtableInitialized = true;
}

abstract class PersisterInterface {}

final _PersisterFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_persister(ptr, status));
});

class Persister implements PersisterInterface {
  late final Pointer<Void> _ptr;
  Persister._(this._ptr) {
    _PersisterFinalizer.attach(this, _ptr, detach: this);
  }
  Persister.custom(Persistence persistence)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_persister_custom(
          FfiConverterCallbackInterfacePersistence.lower(persistence),
          status,
        ),
        null,
      ) {
    _PersisterFinalizer.attach(this, _ptr, detach: this);
  }
  Persister.newInMemory()
    : _ptr = rustCall(
        (status) =>
            uniffi_bdk_ffi_fn_constructor_persister_new_in_memory(status),
        persistenceExceptionErrorHandler,
      ) {
    _PersisterFinalizer.attach(this, _ptr, detach: this);
  }
  Persister.newSqlite(String path)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_persister_new_sqlite(
          FfiConverterString.lower(path),
          status,
        ),
        persistenceExceptionErrorHandler,
      ) {
    _PersisterFinalizer.attach(this, _ptr, detach: this);
  }
  factory Persister.lift(Pointer<Void> ptr) {
    return Persister._(ptr);
  }
  static Pointer<Void> lower(Persister value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_persister(_ptr, status),
    );
  }

  static int allocationSize(Persister value) {
    return 8;
  }

  static LiftRetVal<Persister> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Persister.lift(pointer), 8);
  }

  static int write(Persister value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _PersisterFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_persister(_ptr, status));
  }
}

abstract class PolicyInterface {
  String asString();
  Satisfaction contribution();
  String id();
  SatisfiableItem item();
  bool requiresPath();
  Satisfaction satisfaction();
}

final _PolicyFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_policy(ptr, status));
});

class Policy implements PolicyInterface {
  late final Pointer<Void> _ptr;
  Policy._(this._ptr) {
    _PolicyFinalizer.attach(this, _ptr, detach: this);
  }
  factory Policy.lift(Pointer<Void> ptr) {
    return Policy._(ptr);
  }
  static Pointer<Void> lower(Policy value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_policy(_ptr, status));
  }

  static int allocationSize(Policy value) {
    return 8;
  }

  static LiftRetVal<Policy> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Policy.lift(pointer), 8);
  }

  static int write(Policy value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _PolicyFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_policy(_ptr, status));
  }

  String asString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_policy_as_string(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  Satisfaction contribution() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_policy_contribution(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSatisfaction.lift,
      null,
    );
  }

  String id() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_policy_id(uniffiClonePointer(), status),
      FfiConverterString.lift,
      null,
    );
  }

  SatisfiableItem item() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_policy_item(uniffiClonePointer(), status),
      FfiConverterSatisfiableItem.lift,
      null,
    );
  }

  bool requiresPath() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_policy_requires_path(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  Satisfaction satisfaction() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_policy_satisfaction(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSatisfaction.lift,
      null,
    );
  }
}

abstract class PsbtInterface {
  Psbt combine(Psbt other);
  Transaction extractTx();
  int fee();
  FinalizedPsbtResult finalize();
  List<Input> input();
  String jsonSerialize();
  List<Output> output();
  String serialize();
  String spendUtxo(int inputIndex);
  void writeToFile(String path);
}

final _PsbtFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_psbt(ptr, status));
});

class Psbt implements PsbtInterface {
  late final Pointer<Void> _ptr;
  Psbt._(this._ptr) {
    _PsbtFinalizer.attach(this, _ptr, detach: this);
  }
  Psbt.fromFile(String path)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_psbt_from_file(
          FfiConverterString.lower(path),
          status,
        ),
        psbtExceptionErrorHandler,
      ) {
    _PsbtFinalizer.attach(this, _ptr, detach: this);
  }
  Psbt.fromUnsignedTx(Transaction tx)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_psbt_from_unsigned_tx(
          Transaction.lower(tx),
          status,
        ),
        psbtExceptionErrorHandler,
      ) {
    _PsbtFinalizer.attach(this, _ptr, detach: this);
  }
  Psbt(String psbtBase64)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_psbt_new(
          FfiConverterString.lower(psbtBase64),
          status,
        ),
        psbtParseExceptionErrorHandler,
      ) {
    _PsbtFinalizer.attach(this, _ptr, detach: this);
  }
  factory Psbt.lift(Pointer<Void> ptr) {
    return Psbt._(ptr);
  }
  static Pointer<Void> lower(Psbt value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_psbt(_ptr, status));
  }

  static int allocationSize(Psbt value) {
    return 8;
  }

  static LiftRetVal<Psbt> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Psbt.lift(pointer), 8);
  }

  static int write(Psbt value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _PsbtFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_psbt(_ptr, status));
  }

  Psbt combine(Psbt other) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_psbt_combine(
        uniffiClonePointer(),
        Psbt.lower(other),
        status,
      ),
      Psbt.lift,
      psbtExceptionErrorHandler,
    );
  }

  Transaction extractTx() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_psbt_extract_tx(
        uniffiClonePointer(),
        status,
      ),
      Transaction.lift,
      extractTxExceptionErrorHandler,
    );
  }

  int fee() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_psbt_fee(uniffiClonePointer(), status),
      FfiConverterUInt64.lift,
      psbtExceptionErrorHandler,
    );
  }

  FinalizedPsbtResult finalize() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_psbt_finalize(uniffiClonePointer(), status),
      FfiConverterFinalizedPsbtResult.lift,
      null,
    );
  }

  List<Input> input() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_psbt_input(uniffiClonePointer(), status),
      FfiConverterSequenceInput.lift,
      null,
    );
  }

  String jsonSerialize() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_psbt_json_serialize(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  List<Output> output() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_psbt_output(uniffiClonePointer(), status),
      FfiConverterSequenceOutput.lift,
      null,
    );
  }

  String serialize() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_psbt_serialize(uniffiClonePointer(), status),
      FfiConverterString.lift,
      null,
    );
  }

  String spendUtxo(int inputIndex) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_psbt_spend_utxo(
        uniffiClonePointer(),
        FfiConverterUInt64.lower(inputIndex),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  void writeToFile(String path) {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_psbt_write_to_file(
        uniffiClonePointer(),
        FfiConverterString.lower(path),
        status,
      );
    }, psbtExceptionErrorHandler);
  }
}

abstract class ScriptInterface {
  Uint8List toBytes();
}

final _ScriptFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_script(ptr, status));
});

class Script implements ScriptInterface {
  late final Pointer<Void> _ptr;
  Script._(this._ptr) {
    _ScriptFinalizer.attach(this, _ptr, detach: this);
  }
  Script(Uint8List rawOutputScript)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_script_new(
          FfiConverterUint8List.lower(rawOutputScript),
          status,
        ),
        null,
      ) {
    _ScriptFinalizer.attach(this, _ptr, detach: this);
  }
  factory Script.lift(Pointer<Void> ptr) {
    return Script._(ptr);
  }
  static Pointer<Void> lower(Script value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_script(_ptr, status));
  }

  static int allocationSize(Script value) {
    return 8;
  }

  static LiftRetVal<Script> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Script.lift(pointer), 8);
  }

  static int write(Script value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _ScriptFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_script(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_script_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  Uint8List toBytes() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_script_to_bytes(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUint8List.lift,
      null,
    );
  }
}

abstract class SyncRequestInterface {}

final _SyncRequestFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_syncrequest(ptr, status));
});

class SyncRequest implements SyncRequestInterface {
  late final Pointer<Void> _ptr;
  SyncRequest._(this._ptr) {
    _SyncRequestFinalizer.attach(this, _ptr, detach: this);
  }
  factory SyncRequest.lift(Pointer<Void> ptr) {
    return SyncRequest._(ptr);
  }
  static Pointer<Void> lower(SyncRequest value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_syncrequest(_ptr, status),
    );
  }

  static int allocationSize(SyncRequest value) {
    return 8;
  }

  static LiftRetVal<SyncRequest> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(SyncRequest.lift(pointer), 8);
  }

  static int write(SyncRequest value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _SyncRequestFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_syncrequest(_ptr, status));
  }
}

abstract class SyncRequestBuilderInterface {
  SyncRequest build();
  SyncRequestBuilder inspectSpks(SyncScriptInspector inspector);
}

final _SyncRequestBuilderFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_syncrequestbuilder(ptr, status));
});

class SyncRequestBuilder implements SyncRequestBuilderInterface {
  late final Pointer<Void> _ptr;
  SyncRequestBuilder._(this._ptr) {
    _SyncRequestBuilderFinalizer.attach(this, _ptr, detach: this);
  }
  factory SyncRequestBuilder.lift(Pointer<Void> ptr) {
    return SyncRequestBuilder._(ptr);
  }
  static Pointer<Void> lower(SyncRequestBuilder value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_syncrequestbuilder(_ptr, status),
    );
  }

  static int allocationSize(SyncRequestBuilder value) {
    return 8;
  }

  static LiftRetVal<SyncRequestBuilder> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(SyncRequestBuilder.lift(pointer), 8);
  }

  static int write(SyncRequestBuilder value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _SyncRequestBuilderFinalizer.detach(this);
    rustCall(
      (status) => uniffi_bdk_ffi_fn_free_syncrequestbuilder(_ptr, status),
    );
  }

  SyncRequest build() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_syncrequestbuilder_build(
        uniffiClonePointer(),
        status,
      ),
      SyncRequest.lift,
      requestBuilderExceptionErrorHandler,
    );
  }

  SyncRequestBuilder inspectSpks(SyncScriptInspector inspector) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_syncrequestbuilder_inspect_spks(
        uniffiClonePointer(),
        FfiConverterCallbackInterfaceSyncScriptInspector.lower(inspector),
        status,
      ),
      SyncRequestBuilder.lift,
      requestBuilderExceptionErrorHandler,
    );
  }
}

abstract class SyncScriptInspector {
  void inspect(Script script, int total);
}

class FfiConverterCallbackInterfaceSyncScriptInspector {
  static final _handleMap = UniffiHandleMap<SyncScriptInspector>();
  static bool _vtableInitialized = false;
  static SyncScriptInspector lift(Pointer<Void> handle) {
    return _handleMap.get(handle.address);
  }

  static Pointer<Void> lower(SyncScriptInspector value) {
    _ensureVTableInitialized();
    final handle = _handleMap.insert(value);
    return Pointer<Void>.fromAddress(handle);
  }

  static void _ensureVTableInitialized() {
    if (!_vtableInitialized) {
      initSyncScriptInspectorVTable();
      _vtableInitialized = true;
    }
  }

  static LiftRetVal<SyncScriptInspector> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(lift(pointer), 8);
  }

  static int write(SyncScriptInspector value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  static int allocationSize(SyncScriptInspector value) {
    return 8;
  }
}

typedef UniffiCallbackInterfaceSyncScriptInspectorMethod0 =
    Void Function(
      Uint64,
      Pointer<Void>,
      Uint64,
      Pointer<Void>,
      Pointer<RustCallStatus>,
    );
typedef UniffiCallbackInterfaceSyncScriptInspectorMethod0Dart =
    void Function(
      int,
      Pointer<Void>,
      int,
      Pointer<Void>,
      Pointer<RustCallStatus>,
    );
typedef UniffiCallbackInterfaceSyncScriptInspectorFree = Void Function(Uint64);
typedef UniffiCallbackInterfaceSyncScriptInspectorFreeDart = void Function(int);
typedef UniffiCallbackInterfaceSyncScriptInspectorClone =
    Uint64 Function(Uint64);
typedef UniffiCallbackInterfaceSyncScriptInspectorCloneDart = int Function(int);

final class UniffiVTableCallbackInterfaceSyncScriptInspector extends Struct {
  external Pointer<
    NativeFunction<UniffiCallbackInterfaceSyncScriptInspectorFree>
  >
  uniffiFree;
  external Pointer<
    NativeFunction<UniffiCallbackInterfaceSyncScriptInspectorClone>
  >
  uniffiClone;
  external Pointer<
    NativeFunction<UniffiCallbackInterfaceSyncScriptInspectorMethod0>
  >
  inspect;
}

void syncScriptInspectorInspect(
  int uniffiHandle,
  Pointer<Void> script,
  int total,
  Pointer<Void> outReturn,
  Pointer<RustCallStatus> callStatus,
) {
  final status = callStatus.ref;
  try {
    final obj = FfiConverterCallbackInterfaceSyncScriptInspector._handleMap.get(
      uniffiHandle,
    );
    final arg0 = Script.lift(script);
    final arg1 = FfiConverterUInt64.lift(total);
    obj.inspect(arg0, arg1);
    status.code = CALL_SUCCESS;
  } catch (e) {
    status.code = CALL_UNEXPECTED_ERROR;
    status.errorBuf = FfiConverterString.lower(e.toString());
  }
}

final Pointer<NativeFunction<UniffiCallbackInterfaceSyncScriptInspectorMethod0>>
syncScriptInspectorInspectPointer =
    Pointer.fromFunction<UniffiCallbackInterfaceSyncScriptInspectorMethod0>(
      syncScriptInspectorInspect,
    );
void syncScriptInspectorFreeCallback(int handle) {
  try {
    FfiConverterCallbackInterfaceSyncScriptInspector._handleMap.remove(handle);
  } catch (e) {}
}

final Pointer<NativeFunction<UniffiCallbackInterfaceSyncScriptInspectorFree>>
syncScriptInspectorFreePointer =
    Pointer.fromFunction<UniffiCallbackInterfaceSyncScriptInspectorFree>(
      syncScriptInspectorFreeCallback,
    );
int syncScriptInspectorCloneCallback(int handle) {
  try {
    final obj = FfiConverterCallbackInterfaceSyncScriptInspector._handleMap.get(
      handle,
    );
    final newHandle = FfiConverterCallbackInterfaceSyncScriptInspector
        ._handleMap
        .insert(obj);
    return newHandle;
  } catch (e) {
    return 0;
  }
}

final Pointer<NativeFunction<UniffiCallbackInterfaceSyncScriptInspectorClone>>
syncScriptInspectorClonePointer =
    Pointer.fromFunction<UniffiCallbackInterfaceSyncScriptInspectorClone>(
      syncScriptInspectorCloneCallback,
      0,
    );
late final Pointer<UniffiVTableCallbackInterfaceSyncScriptInspector>
syncScriptInspectorVTable;
void initSyncScriptInspectorVTable() {
  if (FfiConverterCallbackInterfaceSyncScriptInspector._vtableInitialized) {
    return;
  }
  syncScriptInspectorVTable =
      calloc<UniffiVTableCallbackInterfaceSyncScriptInspector>();
  syncScriptInspectorVTable.ref.uniffiFree = syncScriptInspectorFreePointer;
  syncScriptInspectorVTable.ref.uniffiClone = syncScriptInspectorClonePointer;
  syncScriptInspectorVTable.ref.inspect = syncScriptInspectorInspectPointer;
  rustCall((status) {
    uniffi_bdk_ffi_fn_init_callback_vtable_syncscriptinspector(
      syncScriptInspectorVTable,
    );
    checkCallStatus(NullRustCallStatusErrorHandler(), status);
  });
  FfiConverterCallbackInterfaceSyncScriptInspector._vtableInitialized = true;
}

abstract class TapTreeInterface {
  NodeInfo nodeInfo();
  String rootHash();
}

final _TapTreeFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_taptree(ptr, status));
});

class TapTree implements TapTreeInterface {
  late final Pointer<Void> _ptr;
  TapTree._(this._ptr) {
    _TapTreeFinalizer.attach(this, _ptr, detach: this);
  }
  factory TapTree.lift(Pointer<Void> ptr) {
    return TapTree._(ptr);
  }
  static Pointer<Void> lower(TapTree value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_taptree(_ptr, status));
  }

  static int allocationSize(TapTree value) {
    return 8;
  }

  static LiftRetVal<TapTree> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(TapTree.lift(pointer), 8);
  }

  static int write(TapTree value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _TapTreeFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_taptree(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_taptree_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  NodeInfo nodeInfo() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_taptree_node_info(
        uniffiClonePointer(),
        status,
      ),
      NodeInfo.lift,
      null,
    );
  }

  String rootHash() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_taptree_root_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }
}

abstract class TransactionInterface {
  Txid computeTxid();
  Wtxid computeWtxid();
  List<TxIn> input();
  bool isCoinbase();
  bool isExplicitlyRbf();
  bool isLockTimeEnabled();
  int lockTime();
  List<TxOut> output();
  Uint8List serialize();
  int totalSize();
  int version();
  int vsize();
  int weight();
}

final _TransactionFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_transaction(ptr, status));
});

class Transaction implements TransactionInterface {
  late final Pointer<Void> _ptr;
  Transaction._(this._ptr) {
    _TransactionFinalizer.attach(this, _ptr, detach: this);
  }
  Transaction(Uint8List transactionBytes)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_transaction_new(
          FfiConverterUint8List.lower(transactionBytes),
          status,
        ),
        transactionExceptionErrorHandler,
      ) {
    _TransactionFinalizer.attach(this, _ptr, detach: this);
  }
  factory Transaction.lift(Pointer<Void> ptr) {
    return Transaction._(ptr);
  }
  static Pointer<Void> lower(Transaction value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_transaction(_ptr, status),
    );
  }

  static int allocationSize(Transaction value) {
    return 8;
  }

  static LiftRetVal<Transaction> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Transaction.lift(pointer), 8);
  }

  static int write(Transaction value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _TransactionFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_transaction(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Transaction) {
      return false;
    }
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_uniffi_trait_eq_eq(
        uniffiClonePointer(),
        Transaction.lower(other),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  Txid computeTxid() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_compute_txid(
        uniffiClonePointer(),
        status,
      ),
      Txid.lift,
      null,
    );
  }

  Wtxid computeWtxid() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_compute_wtxid(
        uniffiClonePointer(),
        status,
      ),
      Wtxid.lift,
      null,
    );
  }

  List<TxIn> input() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_input(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSequenceTxIn.lift,
      null,
    );
  }

  bool isCoinbase() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_is_coinbase(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  bool isExplicitlyRbf() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_is_explicitly_rbf(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  bool isLockTimeEnabled() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_is_lock_time_enabled(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  int lockTime() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_lock_time(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt32.lift,
      null,
    );
  }

  List<TxOut> output() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_output(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSequenceTxOut.lift,
      null,
    );
  }

  Uint8List serialize() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_serialize(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUint8List.lift,
      null,
    );
  }

  int totalSize() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_total_size(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  int version() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_version(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterInt32.lift,
      null,
    );
  }

  int vsize() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_vsize(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  int weight() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_transaction_weight(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }
}

abstract class TxBuilderInterface {
  TxBuilder addData(Uint8List data);
  TxBuilder addGlobalXpubs();
  TxBuilder addRecipient(Script script, Amount amount);
  TxBuilder addUnspendable(OutPoint unspendable);
  TxBuilder addUtxo(OutPoint outpoint);
  TxBuilder addUtxos(List<OutPoint> outpoints);
  TxBuilder allowDust(bool allowDust);
  TxBuilder changePolicy(ChangeSpendPolicy changePolicy);
  TxBuilder currentHeight(int height);
  TxBuilder doNotSpendChange();
  TxBuilder drainTo(Script script);
  TxBuilder drainWallet();
  TxBuilder excludeBelowConfirmations(int minConfirms);
  TxBuilder excludeUnconfirmed();
  TxBuilder feeAbsolute(Amount feeAmount);
  TxBuilder feeRate(FeeRate feeRate);
  Psbt finish(Wallet wallet);
  TxBuilder manuallySelectedOnly();
  TxBuilder nlocktime(LockTime locktime);
  TxBuilder onlySpendChange();
  TxBuilder policyPath(
    Map<String, List<int>> policyPath,
    KeychainKind keychain,
  );
  TxBuilder setExactSequence(int nsequence);
  TxBuilder setRecipients(List<ScriptAmount> recipients);
  TxBuilder unspendable(List<OutPoint> unspendable);
  TxBuilder version(int version);
}

final _TxBuilderFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_txbuilder(ptr, status));
});

class TxBuilder implements TxBuilderInterface {
  late final Pointer<Void> _ptr;
  TxBuilder._(this._ptr) {
    _TxBuilderFinalizer.attach(this, _ptr, detach: this);
  }
  TxBuilder()
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_txbuilder_new(status),
        null,
      ) {
    _TxBuilderFinalizer.attach(this, _ptr, detach: this);
  }
  factory TxBuilder.lift(Pointer<Void> ptr) {
    return TxBuilder._(ptr);
  }
  static Pointer<Void> lower(TxBuilder value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_txbuilder(_ptr, status),
    );
  }

  static int allocationSize(TxBuilder value) {
    return 8;
  }

  static LiftRetVal<TxBuilder> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(TxBuilder.lift(pointer), 8);
  }

  static int write(TxBuilder value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _TxBuilderFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_txbuilder(_ptr, status));
  }

  TxBuilder addData(Uint8List data) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_add_data(
        uniffiClonePointer(),
        FfiConverterUint8List.lower(data),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder addGlobalXpubs() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_add_global_xpubs(
        uniffiClonePointer(),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder addRecipient(Script script, Amount amount) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_add_recipient(
        uniffiClonePointer(),
        Script.lower(script),
        Amount.lower(amount),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder addUnspendable(OutPoint unspendable) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_add_unspendable(
        uniffiClonePointer(),
        FfiConverterOutPoint.lower(unspendable),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder addUtxo(OutPoint outpoint) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_add_utxo(
        uniffiClonePointer(),
        FfiConverterOutPoint.lower(outpoint),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder addUtxos(List<OutPoint> outpoints) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_add_utxos(
        uniffiClonePointer(),
        FfiConverterSequenceOutPoint.lower(outpoints),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder allowDust(bool allowDust) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_allow_dust(
        uniffiClonePointer(),
        FfiConverterBool.lower(allowDust),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder changePolicy(ChangeSpendPolicy changePolicy) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_change_policy(
        uniffiClonePointer(),
        FfiConverterChangeSpendPolicy.lower(changePolicy),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder currentHeight(int height) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_current_height(
        uniffiClonePointer(),
        FfiConverterUInt32.lower(height),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder doNotSpendChange() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_do_not_spend_change(
        uniffiClonePointer(),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder drainTo(Script script) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_drain_to(
        uniffiClonePointer(),
        Script.lower(script),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder drainWallet() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_drain_wallet(
        uniffiClonePointer(),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder excludeBelowConfirmations(int minConfirms) {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_txbuilder_exclude_below_confirmations(
            uniffiClonePointer(),
            FfiConverterUInt32.lower(minConfirms),
            status,
          ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder excludeUnconfirmed() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_exclude_unconfirmed(
        uniffiClonePointer(),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder feeAbsolute(Amount feeAmount) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_fee_absolute(
        uniffiClonePointer(),
        Amount.lower(feeAmount),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder feeRate(FeeRate feeRate) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_fee_rate(
        uniffiClonePointer(),
        FeeRate.lower(feeRate),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  Psbt finish(Wallet wallet) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_finish(
        uniffiClonePointer(),
        Wallet.lower(wallet),
        status,
      ),
      Psbt.lift,
      createTxExceptionErrorHandler,
    );
  }

  TxBuilder manuallySelectedOnly() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_manually_selected_only(
        uniffiClonePointer(),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder nlocktime(LockTime locktime) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_nlocktime(
        uniffiClonePointer(),
        FfiConverterLockTime.lower(locktime),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder onlySpendChange() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_only_spend_change(
        uniffiClonePointer(),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder policyPath(
    Map<String, List<int>> policyPath,
    KeychainKind keychain,
  ) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_policy_path(
        uniffiClonePointer(),
        FfiConverterMapStringToSequenceUInt64.lower(policyPath),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder setExactSequence(int nsequence) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_set_exact_sequence(
        uniffiClonePointer(),
        FfiConverterUInt32.lower(nsequence),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder setRecipients(List<ScriptAmount> recipients) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_set_recipients(
        uniffiClonePointer(),
        FfiConverterSequenceScriptAmount.lower(recipients),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder unspendable(List<OutPoint> unspendable) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_unspendable(
        uniffiClonePointer(),
        FfiConverterSequenceOutPoint.lower(unspendable),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }

  TxBuilder version(int version) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txbuilder_version(
        uniffiClonePointer(),
        FfiConverterInt32.lower(version),
        status,
      ),
      TxBuilder.lift,
      null,
    );
  }
}

abstract class TxMerkleNodeInterface {
  Uint8List serialize();
}

final _TxMerkleNodeFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_txmerklenode(ptr, status));
});

class TxMerkleNode implements TxMerkleNodeInterface {
  late final Pointer<Void> _ptr;
  TxMerkleNode._(this._ptr) {
    _TxMerkleNodeFinalizer.attach(this, _ptr, detach: this);
  }
  TxMerkleNode.fromBytes(Uint8List bytes)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_txmerklenode_from_bytes(
          FfiConverterUint8List.lower(bytes),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _TxMerkleNodeFinalizer.attach(this, _ptr, detach: this);
  }
  TxMerkleNode.fromString(String hex)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_txmerklenode_from_string(
          FfiConverterString.lower(hex),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _TxMerkleNodeFinalizer.attach(this, _ptr, detach: this);
  }
  factory TxMerkleNode.lift(Pointer<Void> ptr) {
    return TxMerkleNode._(ptr);
  }
  static Pointer<Void> lower(TxMerkleNode value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall(
      (status) => uniffi_bdk_ffi_fn_clone_txmerklenode(_ptr, status),
    );
  }

  static int allocationSize(TxMerkleNode value) {
    return 8;
  }

  static LiftRetVal<TxMerkleNode> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(TxMerkleNode.lift(pointer), 8);
  }

  static int write(TxMerkleNode value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _TxMerkleNodeFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_txmerklenode(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txmerklenode_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! TxMerkleNode) {
      return false;
    }
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txmerklenode_uniffi_trait_eq_eq(
        uniffiClonePointer(),
        TxMerkleNode.lower(other),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  @override
  int get hashCode {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txmerklenode_uniffi_trait_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  Uint8List serialize() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txmerklenode_serialize(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUint8List.lift,
      null,
    );
  }
}

abstract class TxidInterface {
  Uint8List serialize();
}

final _TxidFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_txid(ptr, status));
});

class Txid implements TxidInterface {
  late final Pointer<Void> _ptr;
  Txid._(this._ptr) {
    _TxidFinalizer.attach(this, _ptr, detach: this);
  }
  Txid.fromBytes(Uint8List bytes)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_txid_from_bytes(
          FfiConverterUint8List.lower(bytes),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _TxidFinalizer.attach(this, _ptr, detach: this);
  }
  Txid.fromString(String hex)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_txid_from_string(
          FfiConverterString.lower(hex),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _TxidFinalizer.attach(this, _ptr, detach: this);
  }
  factory Txid.lift(Pointer<Void> ptr) {
    return Txid._(ptr);
  }
  static Pointer<Void> lower(Txid value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_txid(_ptr, status));
  }

  static int allocationSize(Txid value) {
    return 8;
  }

  static LiftRetVal<Txid> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Txid.lift(pointer), 8);
  }

  static int write(Txid value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _TxidFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_txid(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txid_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Txid) {
      return false;
    }
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txid_uniffi_trait_eq_eq(
        uniffiClonePointer(),
        Txid.lower(other),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  @override
  int get hashCode {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_txid_uniffi_trait_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  Uint8List serialize() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_txid_serialize(uniffiClonePointer(), status),
      FfiConverterUint8List.lift,
      null,
    );
  }
}

abstract class UpdateInterface {}

final _UpdateFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_update(ptr, status));
});

class Update implements UpdateInterface {
  late final Pointer<Void> _ptr;
  Update._(this._ptr) {
    _UpdateFinalizer.attach(this, _ptr, detach: this);
  }
  factory Update.lift(Pointer<Void> ptr) {
    return Update._(ptr);
  }
  static Pointer<Void> lower(Update value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_update(_ptr, status));
  }

  static int allocationSize(Update value) {
    return 8;
  }

  static LiftRetVal<Update> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Update.lift(pointer), 8);
  }

  static int write(Update value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _UpdateFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_update(_ptr, status));
  }
}

abstract class WalletInterface {
  void applyEvictedTxs(List<EvictedTx> evictedTxs);
  void applyUnconfirmedTxs(List<UnconfirmedTx> unconfirmedTxs);
  void applyUpdate(Update update);
  List<WalletEvent> applyUpdateEvents(Update update);
  Balance balance();
  Amount calculateFee(Transaction tx);
  FeeRate calculateFeeRate(Transaction tx);
  void cancelTx(Transaction tx);
  int? derivationIndex(KeychainKind keychain);
  KeychainAndIndex? derivationOfSpk(Script spk);
  String descriptorChecksum(KeychainKind keychain);
  bool finalizePsbt(Psbt psbt, SignOptions? signOptions);
  CanonicalTx? getTx(Txid txid);
  LocalOutput? getUtxo(OutPoint op);
  void insertTxout(OutPoint outpoint, TxOut txout);
  bool isMine(Script script);
  BlockId latestCheckpoint();
  List<LocalOutput> listOutput();
  List<LocalOutput> listUnspent();
  List<AddressInfo> listUnusedAddresses(KeychainKind keychain);
  bool markUsed(KeychainKind keychain, int index);
  Network network();
  int nextDerivationIndex(KeychainKind keychain);
  AddressInfo nextUnusedAddress(KeychainKind keychain);
  AddressInfo peekAddress(KeychainKind keychain, int index);
  bool persist(Persister persister);
  Policy? policies(KeychainKind keychain);
  String publicDescriptor(KeychainKind keychain);
  List<AddressInfo> revealAddressesTo(KeychainKind keychain, int index);
  AddressInfo revealNextAddress(KeychainKind keychain);
  SentAndReceivedValues sentAndReceived(Transaction tx);
  bool sign(Psbt psbt, SignOptions? signOptions);
  ChangeSet? staged();
  FullScanRequestBuilder startFullScan();
  SyncRequestBuilder startSyncWithRevealedSpks();
  ChangeSet? takeStaged();
  List<CanonicalTx> transactions();
  TxDetails? txDetails(Txid txid);
  bool unmarkUsed(KeychainKind keychain, int index);
}

final _WalletFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_wallet(ptr, status));
});

class Wallet implements WalletInterface {
  late final Pointer<Void> _ptr;
  Wallet._(this._ptr) {
    _WalletFinalizer.attach(this, _ptr, detach: this);
  }
  Wallet.createFromTwoPathDescriptor(
    Descriptor twoPathDescriptor,
    Network network,
    Persister persister,
    int lookahead,
  ) : _ptr = rustCall(
        (status) =>
            uniffi_bdk_ffi_fn_constructor_wallet_create_from_two_path_descriptor(
              Descriptor.lower(twoPathDescriptor),
              FfiConverterNetwork.lower(network),
              Persister.lower(persister),
              FfiConverterUInt32.lower(lookahead),
              status,
            ),
        createWithPersistExceptionErrorHandler,
      ) {
    _WalletFinalizer.attach(this, _ptr, detach: this);
  }
  Wallet.createSingle(
    Descriptor descriptor,
    Network network,
    Persister persister,
    int lookahead,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_wallet_create_single(
          Descriptor.lower(descriptor),
          FfiConverterNetwork.lower(network),
          Persister.lower(persister),
          FfiConverterUInt32.lower(lookahead),
          status,
        ),
        createWithPersistExceptionErrorHandler,
      ) {
    _WalletFinalizer.attach(this, _ptr, detach: this);
  }
  Wallet.load(
    Descriptor descriptor,
    Descriptor changeDescriptor,
    Persister persister,
    int lookahead,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_wallet_load(
          Descriptor.lower(descriptor),
          Descriptor.lower(changeDescriptor),
          Persister.lower(persister),
          FfiConverterUInt32.lower(lookahead),
          status,
        ),
        loadWithPersistExceptionErrorHandler,
      ) {
    _WalletFinalizer.attach(this, _ptr, detach: this);
  }
  Wallet.loadSingle(Descriptor descriptor, Persister persister, int lookahead)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_wallet_load_single(
          Descriptor.lower(descriptor),
          Persister.lower(persister),
          FfiConverterUInt32.lower(lookahead),
          status,
        ),
        loadWithPersistExceptionErrorHandler,
      ) {
    _WalletFinalizer.attach(this, _ptr, detach: this);
  }
  Wallet(
    Descriptor descriptor,
    Descriptor changeDescriptor,
    Network network,
    Persister persister,
    int lookahead,
  ) : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_wallet_new(
          Descriptor.lower(descriptor),
          Descriptor.lower(changeDescriptor),
          FfiConverterNetwork.lower(network),
          Persister.lower(persister),
          FfiConverterUInt32.lower(lookahead),
          status,
        ),
        createWithPersistExceptionErrorHandler,
      ) {
    _WalletFinalizer.attach(this, _ptr, detach: this);
  }
  factory Wallet.lift(Pointer<Void> ptr) {
    return Wallet._(ptr);
  }
  static Pointer<Void> lower(Wallet value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_wallet(_ptr, status));
  }

  static int allocationSize(Wallet value) {
    return 8;
  }

  static LiftRetVal<Wallet> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Wallet.lift(pointer), 8);
  }

  static int write(Wallet value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _WalletFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_wallet(_ptr, status));
  }

  void applyEvictedTxs(List<EvictedTx> evictedTxs) {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_wallet_apply_evicted_txs(
        uniffiClonePointer(),
        FfiConverterSequenceEvictedTx.lower(evictedTxs),
        status,
      );
    }, null);
  }

  void applyUnconfirmedTxs(List<UnconfirmedTx> unconfirmedTxs) {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_wallet_apply_unconfirmed_txs(
        uniffiClonePointer(),
        FfiConverterSequenceUnconfirmedTx.lower(unconfirmedTxs),
        status,
      );
    }, null);
  }

  void applyUpdate(Update update) {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_wallet_apply_update(
        uniffiClonePointer(),
        Update.lower(update),
        status,
      );
    }, cannotConnectExceptionErrorHandler);
  }

  List<WalletEvent> applyUpdateEvents(Update update) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_apply_update_events(
        uniffiClonePointer(),
        Update.lower(update),
        status,
      ),
      FfiConverterSequenceWalletEvent.lift,
      cannotConnectExceptionErrorHandler,
    );
  }

  Balance balance() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_wallet_balance(uniffiClonePointer(), status),
      FfiConverterBalance.lift,
      null,
    );
  }

  Amount calculateFee(Transaction tx) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_calculate_fee(
        uniffiClonePointer(),
        Transaction.lower(tx),
        status,
      ),
      Amount.lift,
      calculateFeeExceptionErrorHandler,
    );
  }

  FeeRate calculateFeeRate(Transaction tx) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_calculate_fee_rate(
        uniffiClonePointer(),
        Transaction.lower(tx),
        status,
      ),
      FeeRate.lift,
      calculateFeeExceptionErrorHandler,
    );
  }

  void cancelTx(Transaction tx) {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_wallet_cancel_tx(
        uniffiClonePointer(),
        Transaction.lower(tx),
        status,
      );
    }, null);
  }

  int? derivationIndex(KeychainKind keychain) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_derivation_index(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      FfiConverterOptionalUInt32.lift,
      null,
    );
  }

  KeychainAndIndex? derivationOfSpk(Script spk) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_derivation_of_spk(
        uniffiClonePointer(),
        Script.lower(spk),
        status,
      ),
      FfiConverterOptionalKeychainAndIndex.lift,
      null,
    );
  }

  String descriptorChecksum(KeychainKind keychain) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_descriptor_checksum(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  bool finalizePsbt(Psbt psbt, SignOptions? signOptions) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_finalize_psbt(
        uniffiClonePointer(),
        Psbt.lower(psbt),
        FfiConverterOptionalSignOptions.lower(signOptions),
        status,
      ),
      FfiConverterBool.lift,
      signerExceptionErrorHandler,
    );
  }

  CanonicalTx? getTx(Txid txid) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_get_tx(
        uniffiClonePointer(),
        Txid.lower(txid),
        status,
      ),
      FfiConverterOptionalCanonicalTx.lift,
      txidParseExceptionErrorHandler,
    );
  }

  LocalOutput? getUtxo(OutPoint op) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_get_utxo(
        uniffiClonePointer(),
        FfiConverterOutPoint.lower(op),
        status,
      ),
      FfiConverterOptionalLocalOutput.lift,
      null,
    );
  }

  void insertTxout(OutPoint outpoint, TxOut txout) {
    return rustCall((status) {
      uniffi_bdk_ffi_fn_method_wallet_insert_txout(
        uniffiClonePointer(),
        FfiConverterOutPoint.lower(outpoint),
        FfiConverterTxOut.lower(txout),
        status,
      );
    }, null);
  }

  bool isMine(Script script) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_is_mine(
        uniffiClonePointer(),
        Script.lower(script),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  BlockId latestCheckpoint() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_latest_checkpoint(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterBlockId.lift,
      null,
    );
  }

  List<LocalOutput> listOutput() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_list_output(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSequenceLocalOutput.lift,
      null,
    );
  }

  List<LocalOutput> listUnspent() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_list_unspent(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSequenceLocalOutput.lift,
      null,
    );
  }

  List<AddressInfo> listUnusedAddresses(KeychainKind keychain) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_list_unused_addresses(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      FfiConverterSequenceAddressInfo.lift,
      null,
    );
  }

  bool markUsed(KeychainKind keychain, int index) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_mark_used(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        FfiConverterUInt32.lower(index),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  Network network() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_wallet_network(uniffiClonePointer(), status),
      FfiConverterNetwork.lift,
      null,
    );
  }

  int nextDerivationIndex(KeychainKind keychain) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_next_derivation_index(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      FfiConverterUInt32.lift,
      null,
    );
  }

  AddressInfo nextUnusedAddress(KeychainKind keychain) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_next_unused_address(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      FfiConverterAddressInfo.lift,
      null,
    );
  }

  AddressInfo peekAddress(KeychainKind keychain, int index) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_peek_address(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        FfiConverterUInt32.lower(index),
        status,
      ),
      FfiConverterAddressInfo.lift,
      null,
    );
  }

  bool persist(Persister persister) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_persist(
        uniffiClonePointer(),
        Persister.lower(persister),
        status,
      ),
      FfiConverterBool.lift,
      persistenceExceptionErrorHandler,
    );
  }

  Policy? policies(KeychainKind keychain) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_policies(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      FfiConverterOptionalPolicy.lift,
      descriptorExceptionErrorHandler,
    );
  }

  String publicDescriptor(KeychainKind keychain) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_public_descriptor(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  List<AddressInfo> revealAddressesTo(KeychainKind keychain, int index) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_reveal_addresses_to(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        FfiConverterUInt32.lower(index),
        status,
      ),
      FfiConverterSequenceAddressInfo.lift,
      null,
    );
  }

  AddressInfo revealNextAddress(KeychainKind keychain) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_reveal_next_address(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        status,
      ),
      FfiConverterAddressInfo.lift,
      null,
    );
  }

  SentAndReceivedValues sentAndReceived(Transaction tx) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_sent_and_received(
        uniffiClonePointer(),
        Transaction.lower(tx),
        status,
      ),
      FfiConverterSentAndReceivedValues.lift,
      null,
    );
  }

  bool sign(Psbt psbt, SignOptions? signOptions) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_sign(
        uniffiClonePointer(),
        Psbt.lower(psbt),
        FfiConverterOptionalSignOptions.lower(signOptions),
        status,
      ),
      FfiConverterBool.lift,
      signerExceptionErrorHandler,
    );
  }

  ChangeSet? staged() {
    return rustCallWithLifter(
      (status) =>
          uniffi_bdk_ffi_fn_method_wallet_staged(uniffiClonePointer(), status),
      FfiConverterOptionalChangeSet.lift,
      null,
    );
  }

  FullScanRequestBuilder startFullScan() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_start_full_scan(
        uniffiClonePointer(),
        status,
      ),
      FullScanRequestBuilder.lift,
      null,
    );
  }

  SyncRequestBuilder startSyncWithRevealedSpks() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_start_sync_with_revealed_spks(
        uniffiClonePointer(),
        status,
      ),
      SyncRequestBuilder.lift,
      null,
    );
  }

  ChangeSet? takeStaged() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_take_staged(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterOptionalChangeSet.lift,
      null,
    );
  }

  List<CanonicalTx> transactions() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_transactions(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterSequenceCanonicalTx.lift,
      null,
    );
  }

  TxDetails? txDetails(Txid txid) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_tx_details(
        uniffiClonePointer(),
        Txid.lower(txid),
        status,
      ),
      FfiConverterOptionalTxDetails.lift,
      null,
    );
  }

  bool unmarkUsed(KeychainKind keychain, int index) {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wallet_unmark_used(
        uniffiClonePointer(),
        FfiConverterKeychainKind.lower(keychain),
        FfiConverterUInt32.lower(index),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }
}

abstract class WtxidInterface {
  Uint8List serialize();
}

final _WtxidFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) => uniffi_bdk_ffi_fn_free_wtxid(ptr, status));
});

class Wtxid implements WtxidInterface {
  late final Pointer<Void> _ptr;
  Wtxid._(this._ptr) {
    _WtxidFinalizer.attach(this, _ptr, detach: this);
  }
  Wtxid.fromBytes(Uint8List bytes)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_wtxid_from_bytes(
          FfiConverterUint8List.lower(bytes),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _WtxidFinalizer.attach(this, _ptr, detach: this);
  }
  Wtxid.fromString(String hex)
    : _ptr = rustCall(
        (status) => uniffi_bdk_ffi_fn_constructor_wtxid_from_string(
          FfiConverterString.lower(hex),
          status,
        ),
        hashParseExceptionErrorHandler,
      ) {
    _WtxidFinalizer.attach(this, _ptr, detach: this);
  }
  factory Wtxid.lift(Pointer<Void> ptr) {
    return Wtxid._(ptr);
  }
  static Pointer<Void> lower(Wtxid value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) => uniffi_bdk_ffi_fn_clone_wtxid(_ptr, status));
  }

  static int allocationSize(Wtxid value) {
    return 8;
  }

  static LiftRetVal<Wtxid> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Wtxid.lift(pointer), 8);
  }

  static int write(Wtxid value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _WtxidFinalizer.detach(this);
    rustCall((status) => uniffi_bdk_ffi_fn_free_wtxid(_ptr, status));
  }

  @override
  String toString() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wtxid_uniffi_trait_display(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterString.lift,
      null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Wtxid) {
      return false;
    }
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wtxid_uniffi_trait_eq_eq(
        uniffiClonePointer(),
        Wtxid.lower(other),
        status,
      ),
      FfiConverterBool.lift,
      null,
    );
  }

  @override
  int get hashCode {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wtxid_uniffi_trait_hash(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUInt64.lift,
      null,
    );
  }

  Uint8List serialize() {
    return rustCallWithLifter(
      (status) => uniffi_bdk_ffi_fn_method_wtxid_serialize(
        uniffiClonePointer(),
        status,
      ),
      FfiConverterUint8List.lift,
      null,
    );
  }
}

class UniffiInternalError implements Exception {
  static const int bufferOverflow = 0;
  static const int incompleteData = 1;
  static const int unexpectedOptionalTag = 2;
  static const int unexpectedEnumCase = 3;
  static const int unexpectedNullPointer = 4;
  static const int unexpectedRustCallStatusCode = 5;
  static const int unexpectedRustCallError = 6;
  static const int unexpectedStaleHandle = 7;
  static const int rustPanic = 8;
  final int errorCode;
  final String? panicMessage;
  const UniffiInternalError(this.errorCode, this.panicMessage);
  static UniffiInternalError panicked(String message) {
    return UniffiInternalError(rustPanic, message);
  }

  @override
  String toString() {
    switch (errorCode) {
      case bufferOverflow:
        return "UniFfi::BufferOverflow";
      case incompleteData:
        return "UniFfi::IncompleteData";
      case unexpectedOptionalTag:
        return "UniFfi::UnexpectedOptionalTag";
      case unexpectedEnumCase:
        return "UniFfi::UnexpectedEnumCase";
      case unexpectedNullPointer:
        return "UniFfi::UnexpectedNullPointer";
      case unexpectedRustCallStatusCode:
        return "UniFfi::UnexpectedRustCallStatusCode";
      case unexpectedRustCallError:
        return "UniFfi::UnexpectedRustCallError";
      case unexpectedStaleHandle:
        return "UniFfi::UnexpectedStaleHandle";
      case rustPanic:
        return "UniFfi::rustPanic: $panicMessage";
      default:
        return "UniFfi::UnknownError: $errorCode";
    }
  }
}

const int CALL_SUCCESS = 0;
const int CALL_ERROR = 1;
const int CALL_UNEXPECTED_ERROR = 2;

final class RustCallStatus extends Struct {
  @Int8()
  external int code;
  external RustBuffer errorBuf;
}

void checkCallStatus(
  UniffiRustCallStatusErrorHandler errorHandler,
  Pointer<RustCallStatus> status,
) {
  if (status.ref.code == CALL_SUCCESS) {
    return;
  } else if (status.ref.code == CALL_ERROR) {
    throw errorHandler.lift(status.ref.errorBuf);
  } else if (status.ref.code == CALL_UNEXPECTED_ERROR) {
    if (status.ref.errorBuf.len > 0) {
      throw UniffiInternalError.panicked(
        FfiConverterString.lift(status.ref.errorBuf),
      );
    } else {
      throw UniffiInternalError.panicked("Rust panic");
    }
  } else {
    throw UniffiInternalError.panicked(
      "Unexpected RustCallStatus code: \${status.ref.code}",
    );
  }
}

T rustCall<T>(
  T Function(Pointer<RustCallStatus>) callback, [
  UniffiRustCallStatusErrorHandler? errorHandler,
]) {
  final status = calloc<RustCallStatus>();
  try {
    final result = callback(status);
    checkCallStatus(errorHandler ?? NullRustCallStatusErrorHandler(), status);
    return result;
  } finally {
    calloc.free(status);
  }
}

T rustCallWithLifter<T, F>(
  F Function(Pointer<RustCallStatus>) ffiCall,
  T Function(F) lifter, [
  UniffiRustCallStatusErrorHandler? errorHandler,
]) {
  final status = calloc<RustCallStatus>();
  try {
    final rawResult = ffiCall(status);
    checkCallStatus(errorHandler ?? NullRustCallStatusErrorHandler(), status);
    return lifter(rawResult);
  } finally {
    calloc.free(status);
  }
}

class NullRustCallStatusErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    errorBuf.free();
    return UniffiInternalError.panicked("Unexpected CALL_ERROR");
  }
}

abstract class UniffiRustCallStatusErrorHandler {
  Exception lift(RustBuffer errorBuf);
}

final class RustBuffer extends Struct {
  @Uint64()
  external int capacity;
  @Uint64()
  external int len;
  external Pointer<Uint8> data;
  static RustBuffer alloc(int size) {
    return rustCall((status) => ffi_bdk_ffi_rustbuffer_alloc(size, status));
  }

  static RustBuffer fromBytes(ForeignBytes bytes) {
    return rustCall(
      (status) => ffi_bdk_ffi_rustbuffer_from_bytes(bytes, status),
    );
  }

  void free() {
    rustCall((status) => ffi_bdk_ffi_rustbuffer_free(this, status));
  }

  RustBuffer reserve(int additionalCapacity) {
    return rustCall(
      (status) =>
          ffi_bdk_ffi_rustbuffer_reserve(this, additionalCapacity, status),
    );
  }

  Uint8List asUint8List() {
    final dataList = data.asTypedList(len);
    final byteData = ByteData.sublistView(dataList);
    return Uint8List.view(byteData.buffer);
  }

  @override
  String toString() {
    return "RustBuffer{capacity: \$capacity, len: \$len, data: \$data}";
  }
}

RustBuffer toRustBuffer(Uint8List data) {
  final length = data.length;
  final Pointer<Uint8> frameData = calloc<Uint8>(length);
  final pointerList = frameData.asTypedList(length);
  pointerList.setAll(0, data);
  final bytes = calloc<ForeignBytes>();
  bytes.ref.len = length;
  bytes.ref.data = frameData;
  return RustBuffer.fromBytes(bytes.ref);
}

final class ForeignBytes extends Struct {
  @Int32()
  external int len;
  external Pointer<Uint8> data;
  void free() {
    calloc.free(data);
  }
}

class LiftRetVal<T> {
  final T value;
  final int bytesRead;
  const LiftRetVal(this.value, this.bytesRead);
  LiftRetVal<T> copyWithOffset(int offset) {
    return LiftRetVal(value, bytesRead + offset);
  }
}

abstract class FfiConverter<D, F> {
  const FfiConverter();
  D lift(F value);
  F lower(D value);
  D read(ByteData buffer, int offset);
  void write(D value, ByteData buffer, int offset);
  int size(D value);
}

mixin FfiConverterPrimitive<T> on FfiConverter<T, T> {
  @override
  T lift(T value) => value;
  @override
  T lower(T value) => value;
}
Uint8List createUint8ListFromInt(int value) {
  int length = value.bitLength ~/ 8 + 1;
  if (length != 4 && length != 8) {
    length = (value < 0x100000000) ? 4 : 8;
  }
  Uint8List uint8List = Uint8List(length);
  for (int i = length - 1; i >= 0; i--) {
    uint8List[i] = value & 0xFF;
    value >>= 8;
  }
  return uint8List;
}

class FfiConverterSequenceIpAddress {
  static List<IpAddress> lift(RustBuffer buf) {
    return FfiConverterSequenceIpAddress.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<IpAddress>> read(Uint8List buf) {
    List<IpAddress> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = IpAddress.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<IpAddress> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += IpAddress.write(value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<IpAddress> value) {
    return value
            .map((l) => IpAddress.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<IpAddress> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequencePkOrF {
  static List<PkOrF> lift(RustBuffer buf) {
    return FfiConverterSequencePkOrF.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<PkOrF>> read(Uint8List buf) {
    List<PkOrF> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterPkOrF.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<PkOrF> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterPkOrF.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<PkOrF> value) {
    return value
            .map((l) => FfiConverterPkOrF.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<PkOrF> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalString {
  static String? lift(RustBuffer buf) {
    return FfiConverterOptionalString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<String?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterString.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<String?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([String? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterString.allocationSize(value) + 1;
  }

  static RustBuffer lower(String? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalString.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalString.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(String? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterString.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterBool {
  static bool lift(int value) {
    return value == 1;
  }

  static int lower(bool value) {
    return value ? 1 : 0;
  }

  static LiftRetVal<bool> read(Uint8List buf) {
    return LiftRetVal(FfiConverterBool.lift(buf.first), 1);
  }

  static RustBuffer lowerIntoRustBuffer(bool value) {
    return toRustBuffer(Uint8List.fromList([FfiConverterBool.lower(value)]));
  }

  static int allocationSize([bool value = false]) {
    return 1;
  }

  static int write(bool value, Uint8List buf) {
    buf.setAll(0, [value ? 1 : 0]);
    return allocationSize();
  }
}

class FfiConverterMapDescriptorIdToUInt32 {
  static Map<DescriptorId, int> lift(RustBuffer buf) {
    return FfiConverterMapDescriptorIdToUInt32.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<DescriptorId, int>> read(Uint8List buf) {
    final map = <DescriptorId, int>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = DescriptorId.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterUInt32.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<DescriptorId, int> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += DescriptorId.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterUInt32.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<DescriptorId, int> value) {
    return value.entries
        .map(
          (e) =>
              DescriptorId.allocationSize(e.key) +
              FfiConverterUInt32.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<DescriptorId, int> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterMapStringToUint8List {
  static Map<String, Uint8List> lift(RustBuffer buf) {
    return FfiConverterMapStringToUint8List.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<String, Uint8List>> read(Uint8List buf) {
    final map = <String, Uint8List>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterUint8List.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<String, Uint8List> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterString.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterUint8List.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<String, Uint8List> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterString.allocationSize(e.key) +
              FfiConverterUint8List.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<String, Uint8List> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceTxOut {
  static List<TxOut> lift(RustBuffer buf) {
    return FfiConverterSequenceTxOut.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<TxOut>> read(Uint8List buf) {
    List<TxOut> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterTxOut.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<TxOut> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterTxOut.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<TxOut> value) {
    return value
            .map((l) => FfiConverterTxOut.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<TxOut> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceTxIn {
  static List<TxIn> lift(RustBuffer buf) {
    return FfiConverterSequenceTxIn.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<TxIn>> read(Uint8List buf) {
    List<TxIn> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterTxIn.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<TxIn> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterTxIn.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<TxIn> value) {
    return value
            .map((l) => FfiConverterTxIn.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<TxIn> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalScript {
  static Script? lift(RustBuffer buf) {
    return FfiConverterOptionalScript.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Script?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = Script.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<Script?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Script? value]) {
    if (value == null) {
      return 1;
    }
    return Script.allocationSize(value) + 1;
  }

  static RustBuffer lower(Script? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalScript.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalScript.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Script? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return Script.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterMapProprietaryKeyToUint8List {
  static Map<ProprietaryKey, Uint8List> lift(RustBuffer buf) {
    return FfiConverterMapProprietaryKeyToUint8List.read(
      buf.asUint8List(),
    ).value;
  }

  static LiftRetVal<Map<ProprietaryKey, Uint8List>> read(Uint8List buf) {
    final map = <ProprietaryKey, Uint8List>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterProprietaryKey.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += k.bytesRead;
      final v = FfiConverterUint8List.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<ProprietaryKey, Uint8List> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterProprietaryKey.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterUint8List.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<ProprietaryKey, Uint8List> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterProprietaryKey.allocationSize(e.key) +
              FfiConverterUint8List.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<ProprietaryKey, Uint8List> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterMapTapScriptSigKeyToUint8List {
  static Map<TapScriptSigKey, Uint8List> lift(RustBuffer buf) {
    return FfiConverterMapTapScriptSigKeyToUint8List.read(
      buf.asUint8List(),
    ).value;
  }

  static LiftRetVal<Map<TapScriptSigKey, Uint8List>> read(Uint8List buf) {
    final map = <TapScriptSigKey, Uint8List>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterTapScriptSigKey.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += k.bytesRead;
      final v = FfiConverterUint8List.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<TapScriptSigKey, Uint8List> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterTapScriptSigKey.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterUint8List.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<TapScriptSigKey, Uint8List> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterTapScriptSigKey.allocationSize(e.key) +
              FfiConverterUint8List.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<TapScriptSigKey, Uint8List> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterInt64 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getInt64(0), 8);
  }

  static int lower(int value) {
    if (value < -9223372036854775808 || value > 9223372036854775807) {
      throw ArgumentError("Value out of range for i64: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 8;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, lower(value));
    return 8;
  }
}

class FfiConverterOptionalLocalOutput {
  static LocalOutput? lift(RustBuffer buf) {
    return FfiConverterOptionalLocalOutput.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LocalOutput?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterLocalOutput.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<LocalOutput?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([LocalOutput? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterLocalOutput.allocationSize(value) + 1;
  }

  static RustBuffer lower(LocalOutput? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalLocalOutput.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalLocalOutput.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(LocalOutput? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterLocalOutput.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterMapControlBlockToTapScriptEntry {
  static Map<ControlBlock, TapScriptEntry> lift(RustBuffer buf) {
    return FfiConverterMapControlBlockToTapScriptEntry.read(
      buf.asUint8List(),
    ).value;
  }

  static LiftRetVal<Map<ControlBlock, TapScriptEntry>> read(Uint8List buf) {
    final map = <ControlBlock, TapScriptEntry>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterControlBlock.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += k.bytesRead;
      final v = FfiConverterTapScriptEntry.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<ControlBlock, TapScriptEntry> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterControlBlock.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterTapScriptEntry.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<ControlBlock, TapScriptEntry> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterControlBlock.allocationSize(e.key) +
              FfiConverterTapScriptEntry.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<ControlBlock, TapScriptEntry> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceUint8List {
  static List<Uint8List> lift(RustBuffer buf) {
    return FfiConverterSequenceUint8List.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Uint8List>> read(Uint8List buf) {
    List<Uint8List> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterUint8List.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Uint8List> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterUint8List.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Uint8List> value) {
    return value
            .map((l) => FfiConverterUint8List.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Uint8List> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequencePeer {
  static List<Peer> lift(RustBuffer buf) {
    return FfiConverterSequencePeer.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Peer>> read(Uint8List buf) {
    List<Peer> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterPeer.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Peer> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterPeer.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Peer> value) {
    return value
            .map((l) => FfiConverterPeer.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Peer> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceOutput {
  static List<Output> lift(RustBuffer buf) {
    return FfiConverterSequenceOutput.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Output>> read(Uint8List buf) {
    List<Output> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterOutput.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Output> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterOutput.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Output> value) {
    return value
            .map((l) => FfiConverterOutput.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Output> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterMapUInt32ToSequenceCondition {
  static Map<int, List<Condition>> lift(RustBuffer buf) {
    return FfiConverterMapUInt32ToSequenceCondition.read(
      buf.asUint8List(),
    ).value;
  }

  static LiftRetVal<Map<int, List<Condition>>> read(Uint8List buf) {
    final map = <int, List<Condition>>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterUInt32.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterSequenceCondition.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<int, List<Condition>> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterUInt32.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterSequenceCondition.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<int, List<Condition>> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterUInt32.allocationSize(e.key) +
              FfiConverterSequenceCondition.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<int, List<Condition>> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalTapTree {
  static TapTree? lift(RustBuffer buf) {
    return FfiConverterOptionalTapTree.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TapTree?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = TapTree.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<TapTree?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([TapTree? value]) {
    if (value == null) {
      return 1;
    }
    return TapTree.allocationSize(value) + 1;
  }

  static RustBuffer lower(TapTree? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalTapTree.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalTapTree.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(TapTree? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return TapTree.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterInt32 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getInt32(0), 4);
  }

  static int lower(int value) {
    if (value < -2147483648 || value > 2147483647) {
      throw ArgumentError("Value out of range for i32: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 4;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, lower(value));
    return 4;
  }
}

class FfiConverterOptionalTxid {
  static Txid? lift(RustBuffer buf) {
    return FfiConverterOptionalTxid.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Txid?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = Txid.read(Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<Txid?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Txid? value]) {
    if (value == null) {
      return 1;
    }
    return Txid.allocationSize(value) + 1;
  }

  static RustBuffer lower(Txid? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalTxid.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalTxid.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Txid? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return Txid.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterSequenceOutPoint {
  static List<OutPoint> lift(RustBuffer buf) {
    return FfiConverterSequenceOutPoint.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<OutPoint>> read(Uint8List buf) {
    List<OutPoint> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterOutPoint.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<OutPoint> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterOutPoint.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<OutPoint> value) {
    return value
            .map((l) => FfiConverterOutPoint.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<OutPoint> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequencePsbtFinalizeException {
  static List<PsbtFinalizeException>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequencePsbtFinalizeException.read(
      buf.asUint8List(),
    ).value;
  }

  static LiftRetVal<List<PsbtFinalizeException>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequencePsbtFinalizeException.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<List<PsbtFinalizeException>?>(
      result.value,
      result.bytesRead + 1,
    );
  }

  static int allocationSize([List<PsbtFinalizeException>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequencePsbtFinalizeException.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<PsbtFinalizeException>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequencePsbtFinalizeException.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequencePsbtFinalizeException.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<PsbtFinalizeException>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequencePsbtFinalizeException.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterSequencePsbtFinalizeException {
  static List<PsbtFinalizeException> lift(RustBuffer buf) {
    return FfiConverterSequencePsbtFinalizeException.read(
      buf.asUint8List(),
    ).value;
  }

  static LiftRetVal<List<PsbtFinalizeException>> read(Uint8List buf) {
    List<PsbtFinalizeException> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterPsbtFinalizeException.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<PsbtFinalizeException> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterPsbtFinalizeException.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<PsbtFinalizeException> value) {
    return value
            .map((l) => FfiConverterPsbtFinalizeException.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<PsbtFinalizeException> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalCanonicalTx {
  static CanonicalTx? lift(RustBuffer buf) {
    return FfiConverterOptionalCanonicalTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<CanonicalTx?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterCanonicalTx.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<CanonicalTx?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([CanonicalTx? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterCanonicalTx.allocationSize(value) + 1;
  }

  static RustBuffer lower(CanonicalTx? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalCanonicalTx.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalCanonicalTx.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(CanonicalTx? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterCanonicalTx.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterUInt8 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getUint8(0), 1);
  }

  static int lower(int value) {
    if (value < 0 || value > 255) {
      throw ArgumentError("Value out of range for u8: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 1;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setUint8(0, lower(value));
    return 1;
  }
}

class FfiConverterDouble32 {
  static double lift(double value) => value;
  static LiftRetVal<double> read(Uint8List buf) {
    return LiftRetVal(
      buf.buffer.asByteData(buf.offsetInBytes).getFloat32(0),
      4,
    );
  }

  static double lower(double value) => value;
  static int allocationSize([double value = 0]) {
    return 4;
  }

  static int write(double value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setFloat32(0, value);
    return FfiConverterDouble32.allocationSize();
  }
}

class FfiConverterOptionalNetwork {
  static Network? lift(RustBuffer buf) {
    return FfiConverterOptionalNetwork.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Network?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterNetwork.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<Network?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Network? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterNetwork.allocationSize(value) + 1;
  }

  static RustBuffer lower(Network? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalNetwork.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalNetwork.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Network? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterNetwork.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalBlockHash {
  static BlockHash? lift(RustBuffer buf) {
    return FfiConverterOptionalBlockHash.read(buf.asUint8List()).value;
  }

  static LiftRetVal<BlockHash?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = BlockHash.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<BlockHash?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([BlockHash? value]) {
    if (value == null) {
      return 1;
    }
    return BlockHash.allocationSize(value) + 1;
  }

  static RustBuffer lower(BlockHash? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalBlockHash.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalBlockHash.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(BlockHash? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return BlockHash.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterDouble64 {
  static double lift(double value) => value;
  static LiftRetVal<double> read(Uint8List buf) {
    return LiftRetVal(
      buf.buffer.asByteData(buf.offsetInBytes).getFloat64(0),
      8,
    );
  }

  static double lower(double value) => value;
  static int allocationSize([double value = 0]) {
    return 8;
  }

  static int write(double value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setFloat64(0, value);
    return FfiConverterDouble64.allocationSize();
  }
}

class FfiConverterSequencePolicy {
  static List<Policy> lift(RustBuffer buf) {
    return FfiConverterSequencePolicy.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Policy>> read(Uint8List buf) {
    List<Policy> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = Policy.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Policy> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += Policy.write(value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Policy> value) {
    return value.map((l) => Policy.allocationSize(l)).fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Policy> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalUInt32 {
  static int? lift(RustBuffer buf) {
    return FfiConverterOptionalUInt32.read(buf.asUint8List()).value;
  }

  static LiftRetVal<int?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterUInt32.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<int?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([int? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterUInt32.allocationSize(value) + 1;
  }

  static RustBuffer lower(int? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalUInt32.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalUInt32.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(int? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterUInt32.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterMapKeyToUint8List {
  static Map<Key, Uint8List> lift(RustBuffer buf) {
    return FfiConverterMapKeyToUint8List.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<Key, Uint8List>> read(Uint8List buf) {
    final map = <Key, Uint8List>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterKey.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterUint8List.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<Key, Uint8List> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterKey.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterUint8List.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<Key, Uint8List> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterKey.allocationSize(e.key) +
              FfiConverterUint8List.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<Key, Uint8List> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceWalletEvent {
  static List<WalletEvent> lift(RustBuffer buf) {
    return FfiConverterSequenceWalletEvent.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WalletEvent>> read(Uint8List buf) {
    List<WalletEvent> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterWalletEvent.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WalletEvent> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWalletEvent.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WalletEvent> value) {
    return value
            .map((l) => FfiConverterWalletEvent.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WalletEvent> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceChainChange {
  static List<ChainChange> lift(RustBuffer buf) {
    return FfiConverterSequenceChainChange.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<ChainChange>> read(Uint8List buf) {
    List<ChainChange> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterChainChange.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<ChainChange> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterChainChange.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<ChainChange> value) {
    return value
            .map((l) => FfiConverterChainChange.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<ChainChange> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceUnconfirmedTx {
  static List<UnconfirmedTx> lift(RustBuffer buf) {
    return FfiConverterSequenceUnconfirmedTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<UnconfirmedTx>> read(Uint8List buf) {
    List<UnconfirmedTx> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterUnconfirmedTx.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<UnconfirmedTx> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterUnconfirmedTx.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<UnconfirmedTx> value) {
    return value
            .map((l) => FfiConverterUnconfirmedTx.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<UnconfirmedTx> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalChangeSet {
  static ChangeSet? lift(RustBuffer buf) {
    return FfiConverterOptionalChangeSet.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ChangeSet?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = ChangeSet.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<ChangeSet?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([ChangeSet? value]) {
    if (value == null) {
      return 1;
    }
    return ChangeSet.allocationSize(value) + 1;
  }

  static RustBuffer lower(ChangeSet? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalChangeSet.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalChangeSet.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(ChangeSet? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return ChangeSet.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterSequenceString {
  static List<String> lift(RustBuffer buf) {
    return FfiConverterSequenceString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<String>> read(Uint8List buf) {
    List<String> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<String> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterString.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<String> value) {
    return value
            .map((l) => FfiConverterString.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<String> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterUint8List {
  static Uint8List lift(RustBuffer value) {
    return FfiConverterUint8List.read(value.asUint8List()).value;
  }

  static LiftRetVal<Uint8List> read(Uint8List buf) {
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final bytes = Uint8List.view(buf.buffer, buf.offsetInBytes + 4, length);
    return LiftRetVal(bytes, length + 4);
  }

  static RustBuffer lower(Uint8List value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int allocationSize([Uint8List? value]) {
    if (value == null) {
      return 4;
    }
    return 4 + value.length;
  }

  static int write(Uint8List value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    buf.setRange(offset, offset + value.length, value);
    return 4 + value.length;
  }
}

class FfiConverterOptionalTxDetails {
  static TxDetails? lift(RustBuffer buf) {
    return FfiConverterOptionalTxDetails.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TxDetails?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterTxDetails.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<TxDetails?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([TxDetails? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterTxDetails.allocationSize(value) + 1;
  }

  static RustBuffer lower(TxDetails? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalTxDetails.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalTxDetails.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(TxDetails? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterTxDetails.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalSequenceUint8List {
  static List<Uint8List>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceUint8List.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Uint8List>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceUint8List.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<List<Uint8List>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<Uint8List>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceUint8List.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<Uint8List>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceUint8List.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceUint8List.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<Uint8List>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceUint8List.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterMapStringToKeySource {
  static Map<String, KeySource> lift(RustBuffer buf) {
    return FfiConverterMapStringToKeySource.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<String, KeySource>> read(Uint8List buf) {
    final map = <String, KeySource>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterKeySource.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<String, KeySource> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterString.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterKeySource.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<String, KeySource> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterString.allocationSize(e.key) +
              FfiConverterKeySource.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<String, KeySource> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalInt64 {
  static int? lift(RustBuffer buf) {
    return FfiConverterOptionalInt64.read(buf.asUint8List()).value;
  }

  static LiftRetVal<int?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterInt64.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<int?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([int? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterInt64.allocationSize(value) + 1;
  }

  static RustBuffer lower(int? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalInt64.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalInt64.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(int? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterInt64.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterUInt16 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getUint16(0), 2);
  }

  static int lower(int value) {
    if (value < 0 || value > 65535) {
      throw ArgumentError("Value out of range for u16: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 2;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setUint16(0, lower(value));
    return 2;
  }
}

class FfiConverterMapStringToSequenceUInt64 {
  static Map<String, List<int>> lift(RustBuffer buf) {
    return FfiConverterMapStringToSequenceUInt64.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<String, List<int>>> read(Uint8List buf) {
    final map = <String, List<int>>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterSequenceUInt64.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<String, List<int>> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterString.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterSequenceUInt64.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<String, List<int>> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterString.allocationSize(e.key) +
              FfiConverterSequenceUInt64.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<String, List<int>> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceUInt64 {
  static List<int> lift(RustBuffer buf) {
    return FfiConverterSequenceUInt64.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<int>> read(Uint8List buf) {
    List<int> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterUInt64.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<int> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterUInt64.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<int> value) {
    return value
            .map((l) => FfiConverterUInt64.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<int> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterMapTxidToUInt64 {
  static Map<Txid, int> lift(RustBuffer buf) {
    return FfiConverterMapTxidToUInt64.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<Txid, int>> read(Uint8List buf) {
    final map = <Txid, int>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = Txid.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterUInt64.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<Txid, int> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += Txid.write(entry.key, Uint8List.view(buf.buffer, offset));
      offset += FfiConverterUInt64.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<Txid, int> value) {
    return value.entries
        .map(
          (e) =>
              Txid.allocationSize(e.key) +
              FfiConverterUInt64.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<Txid, int> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalUint8List {
  static Uint8List? lift(RustBuffer buf) {
    return FfiConverterOptionalUint8List.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Uint8List?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterUint8List.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<Uint8List?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Uint8List? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterUint8List.allocationSize(value) + 1;
  }

  static RustBuffer lower(Uint8List? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalUint8List.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalUint8List.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Uint8List? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterUint8List.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalTx {
  static Tx? lift(RustBuffer buf) {
    return FfiConverterOptionalTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Tx?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterTx.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<Tx?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Tx? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterTx.allocationSize(value) + 1;
  }

  static RustBuffer lower(Tx? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalTx.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalTx.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Tx? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterTx.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalUInt64 {
  static int? lift(RustBuffer buf) {
    return FfiConverterOptionalUInt64.read(buf.asUint8List()).value;
  }

  static LiftRetVal<int?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterUInt64.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<int?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([int? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterUInt64.allocationSize(value) + 1;
  }

  static RustBuffer lower(int? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalUInt64.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalUInt64.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(int? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterUInt64.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterSequenceDescriptor {
  static List<Descriptor> lift(RustBuffer buf) {
    return FfiConverterSequenceDescriptor.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Descriptor>> read(Uint8List buf) {
    List<Descriptor> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = Descriptor.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Descriptor> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += Descriptor.write(value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Descriptor> value) {
    return value
            .map((l) => Descriptor.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Descriptor> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceConflict {
  static List<Conflict> lift(RustBuffer buf) {
    return FfiConverterSequenceConflict.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Conflict>> read(Uint8List buf) {
    List<Conflict> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterConflict.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Conflict> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterConflict.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Conflict> value) {
    return value
            .map((l) => FfiConverterConflict.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Conflict> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterMapUInt16ToDouble64 {
  static Map<int, double> lift(RustBuffer buf) {
    return FfiConverterMapUInt16ToDouble64.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<int, double>> read(Uint8List buf) {
    final map = <int, double>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterUInt16.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterDouble64.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<int, double> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterUInt16.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterDouble64.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<int, double> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterUInt16.allocationSize(e.key) +
              FfiConverterDouble64.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<int, double> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterUInt64 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getUint64(0), 8);
  }

  static int lower(int value) {
    if (value < 0) {
      throw ArgumentError("Value out of range for u64: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 8;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setUint64(0, lower(value));
    return 8;
  }
}

class FfiConverterSequenceScriptAmount {
  static List<ScriptAmount> lift(RustBuffer buf) {
    return FfiConverterSequenceScriptAmount.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<ScriptAmount>> read(Uint8List buf) {
    List<ScriptAmount> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterScriptAmount.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<ScriptAmount> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterScriptAmount.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<ScriptAmount> value) {
    return value
            .map((l) => FfiConverterScriptAmount.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<ScriptAmount> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterMapStringToTapKeyOrigin {
  static Map<String, TapKeyOrigin> lift(RustBuffer buf) {
    return FfiConverterMapStringToTapKeyOrigin.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<String, TapKeyOrigin>> read(Uint8List buf) {
    final map = <String, TapKeyOrigin>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterTapKeyOrigin.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<String, TapKeyOrigin> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterString.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterTapKeyOrigin.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<String, TapKeyOrigin> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterString.allocationSize(e.key) +
              FfiConverterTapKeyOrigin.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<String, TapKeyOrigin> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalUInt16 {
  static int? lift(RustBuffer buf) {
    return FfiConverterOptionalUInt16.read(buf.asUint8List()).value;
  }

  static LiftRetVal<int?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterUInt16.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<int?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([int? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterUInt16.allocationSize(value) + 1;
  }

  static RustBuffer lower(int? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalUInt16.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalUInt16.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(int? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterUInt16.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterMapHashableOutPointToTxOut {
  static Map<HashableOutPoint, TxOut> lift(RustBuffer buf) {
    return FfiConverterMapHashableOutPointToTxOut.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<HashableOutPoint, TxOut>> read(Uint8List buf) {
    final map = <HashableOutPoint, TxOut>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = HashableOutPoint.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterTxOut.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<HashableOutPoint, TxOut> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += HashableOutPoint.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterTxOut.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<HashableOutPoint, TxOut> value) {
    return value.entries
        .map(
          (e) =>
              HashableOutPoint.allocationSize(e.key) +
              FfiConverterTxOut.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<HashableOutPoint, TxOut> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceAnchor {
  static List<Anchor> lift(RustBuffer buf) {
    return FfiConverterSequenceAnchor.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Anchor>> read(Uint8List buf) {
    List<Anchor> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterAnchor.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Anchor> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterAnchor.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Anchor> value) {
    return value
            .map((l) => FfiConverterAnchor.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Anchor> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalAmount {
  static Amount? lift(RustBuffer buf) {
    return FfiConverterOptionalAmount.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Amount?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = Amount.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<Amount?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Amount? value]) {
    if (value == null) {
      return 1;
    }
    return Amount.allocationSize(value) + 1;
  }

  static RustBuffer lower(Amount? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalAmount.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalAmount.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Amount? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return Amount.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalConfirmationBlockTime {
  static ConfirmationBlockTime? lift(RustBuffer buf) {
    return FfiConverterOptionalConfirmationBlockTime.read(
      buf.asUint8List(),
    ).value;
  }

  static LiftRetVal<ConfirmationBlockTime?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterConfirmationBlockTime.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<ConfirmationBlockTime?>(
      result.value,
      result.bytesRead + 1,
    );
  }

  static int allocationSize([ConfirmationBlockTime? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterConfirmationBlockTime.allocationSize(value) + 1;
  }

  static RustBuffer lower(ConfirmationBlockTime? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalConfirmationBlockTime.allocationSize(
      value,
    );
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalConfirmationBlockTime.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(ConfirmationBlockTime? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterConfirmationBlockTime.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterString {
  static String lift(RustBuffer buf) {
    return utf8.decoder.convert(buf.asUint8List());
  }

  static RustBuffer lower(String value) {
    return toRustBuffer(Utf8Encoder().convert(value));
  }

  static LiftRetVal<String> read(Uint8List buf) {
    final end = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0) + 4;
    return LiftRetVal(utf8.decoder.convert(buf, 4, end), end);
  }

  static int allocationSize([String value = ""]) {
    return utf8.encoder.convert(value).length + 4;
  }

  static int write(String value, Uint8List buf) {
    final list = utf8.encoder.convert(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, list.length);
    buf.setAll(4, list);
    return list.length + 4;
  }
}

class FfiConverterSequenceEvictedTx {
  static List<EvictedTx> lift(RustBuffer buf) {
    return FfiConverterSequenceEvictedTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<EvictedTx>> read(Uint8List buf) {
    List<EvictedTx> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterEvictedTx.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<EvictedTx> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterEvictedTx.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<EvictedTx> value) {
    return value
            .map((l) => FfiConverterEvictedTx.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<EvictedTx> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalPolicy {
  static Policy? lift(RustBuffer buf) {
    return FfiConverterOptionalPolicy.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Policy?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = Policy.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<Policy?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Policy? value]) {
    if (value == null) {
      return 1;
    }
    return Policy.allocationSize(value) + 1;
  }

  static RustBuffer lower(Policy? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalPolicy.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalPolicy.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Policy? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return Policy.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalBool {
  static bool? lift(RustBuffer buf) {
    return FfiConverterOptionalBool.read(buf.asUint8List()).value;
  }

  static LiftRetVal<bool?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterBool.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<bool?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([bool? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterBool.allocationSize(value) + 1;
  }

  static RustBuffer lower(bool? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalBool.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalBool.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(bool? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterBool.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterSequenceCanonicalTx {
  static List<CanonicalTx> lift(RustBuffer buf) {
    return FfiConverterSequenceCanonicalTx.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<CanonicalTx>> read(Uint8List buf) {
    List<CanonicalTx> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterCanonicalTx.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<CanonicalTx> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterCanonicalTx.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<CanonicalTx> value) {
    return value
            .map((l) => FfiConverterCanonicalTx.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<CanonicalTx> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalTxOut {
  static TxOut? lift(RustBuffer buf) {
    return FfiConverterOptionalTxOut.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TxOut?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterTxOut.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<TxOut?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([TxOut? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterTxOut.allocationSize(value) + 1;
  }

  static RustBuffer lower(TxOut? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalTxOut.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalTxOut.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(TxOut? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterTxOut.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterUInt32 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getUint32(0), 4);
  }

  static int lower(int value) {
    if (value < 0 || value > 4294967295) {
      throw ArgumentError("Value out of range for u32: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 4;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setUint32(0, lower(value));
    return 4;
  }
}

class FfiConverterOptionalSignOptions {
  static SignOptions? lift(RustBuffer buf) {
    return FfiConverterOptionalSignOptions.read(buf.asUint8List()).value;
  }

  static LiftRetVal<SignOptions?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSignOptions.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<SignOptions?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([SignOptions? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSignOptions.allocationSize(value) + 1;
  }

  static RustBuffer lower(SignOptions? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSignOptions.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSignOptions.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(SignOptions? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSignOptions.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalDouble32 {
  static double? lift(RustBuffer buf) {
    return FfiConverterOptionalDouble32.read(buf.asUint8List()).value;
  }

  static LiftRetVal<double?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterDouble32.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<double?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([double? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterDouble32.allocationSize(value) + 1;
  }

  static RustBuffer lower(double? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalDouble32.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalDouble32.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(double? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterDouble32.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalKeychainAndIndex {
  static KeychainAndIndex? lift(RustBuffer buf) {
    return FfiConverterOptionalKeychainAndIndex.read(buf.asUint8List()).value;
  }

  static LiftRetVal<KeychainAndIndex?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterKeychainAndIndex.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<KeychainAndIndex?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([KeychainAndIndex? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterKeychainAndIndex.allocationSize(value) + 1;
  }

  static RustBuffer lower(KeychainAndIndex? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalKeychainAndIndex.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalKeychainAndIndex.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(KeychainAndIndex? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterKeychainAndIndex.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterOptionalDescriptor {
  static Descriptor? lift(RustBuffer buf) {
    return FfiConverterOptionalDescriptor.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Descriptor?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = Descriptor.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<Descriptor?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Descriptor? value]) {
    if (value == null) {
      return 1;
    }
    return Descriptor.allocationSize(value) + 1;
  }

  static RustBuffer lower(Descriptor? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalDescriptor.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalDescriptor.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Descriptor? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return Descriptor.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterSequenceCondition {
  static List<Condition> lift(RustBuffer buf) {
    return FfiConverterSequenceCondition.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Condition>> read(Uint8List buf) {
    List<Condition> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterCondition.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Condition> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterCondition.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Condition> value) {
    return value
            .map((l) => FfiConverterCondition.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Condition> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceLocalOutput {
  static List<LocalOutput> lift(RustBuffer buf) {
    return FfiConverterSequenceLocalOutput.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<LocalOutput>> read(Uint8List buf) {
    List<LocalOutput> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterLocalOutput.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<LocalOutput> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterLocalOutput.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<LocalOutput> value) {
    return value
            .map((l) => FfiConverterLocalOutput.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<LocalOutput> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalTransaction {
  static Transaction? lift(RustBuffer buf) {
    return FfiConverterOptionalTransaction.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Transaction?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = Transaction.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<Transaction?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([Transaction? value]) {
    if (value == null) {
      return 1;
    }
    return Transaction.allocationSize(value) + 1;
  }

  static RustBuffer lower(Transaction? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalTransaction.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalTransaction.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(Transaction? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return Transaction.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterSequenceLeafNode {
  static List<LeafNode> lift(RustBuffer buf) {
    return FfiConverterSequenceLeafNode.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<LeafNode>> read(Uint8List buf) {
    List<LeafNode> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = LeafNode.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<LeafNode> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += LeafNode.write(value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<LeafNode> value) {
    return value
            .map((l) => LeafNode.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<LeafNode> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalLockTime {
  static LockTime? lift(RustBuffer buf) {
    return FfiConverterOptionalLockTime.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LockTime?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterLockTime.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<LockTime?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([LockTime? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterLockTime.allocationSize(value) + 1;
  }

  static RustBuffer lower(LockTime? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalLockTime.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalLockTime.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(LockTime? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterLockTime.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterSequenceInput {
  static List<Input> lift(RustBuffer buf) {
    return FfiConverterSequenceInput.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Input>> read(Uint8List buf) {
    List<Input> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterInput.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Input> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterInput.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Input> value) {
    return value
            .map((l) => FfiConverterInput.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Input> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceAddressInfo {
  static List<AddressInfo> lift(RustBuffer buf) {
    return FfiConverterSequenceAddressInfo.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<AddressInfo>> read(Uint8List buf) {
    List<AddressInfo> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterAddressInfo.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<AddressInfo> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterAddressInfo.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<AddressInfo> value) {
    return value
            .map((l) => FfiConverterAddressInfo.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<AddressInfo> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceTransaction {
  static List<Transaction> lift(RustBuffer buf) {
    return FfiConverterSequenceTransaction.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<Transaction>> read(Uint8List buf) {
    List<Transaction> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = Transaction.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<Transaction> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += Transaction.write(value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<Transaction> value) {
    return value
            .map((l) => Transaction.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<Transaction> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalUInt8 {
  static int? lift(RustBuffer buf) {
    return FfiConverterOptionalUInt8.read(buf.asUint8List()).value;
  }

  static LiftRetVal<int?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterUInt8.read(
      Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
    );
    return LiftRetVal<int?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([int? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterUInt8.allocationSize(value) + 1;
  }

  static RustBuffer lower(int? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalUInt8.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalUInt8.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(int? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterUInt8.write(
          value,
          Uint8List.view(buf.buffer, buf.offsetInBytes + 1),
        ) +
        1;
  }
}

class FfiConverterMapSequenceUInt32ToSequenceCondition {
  static Map<List<int>, List<Condition>> lift(RustBuffer buf) {
    return FfiConverterMapSequenceUInt32ToSequenceCondition.read(
      buf.asUint8List(),
    ).value;
  }

  static LiftRetVal<Map<List<int>, List<Condition>>> read(Uint8List buf) {
    final map = <List<int>, List<Condition>>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterSequenceUInt32.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += k.bytesRead;
      final v = FfiConverterSequenceCondition.read(
        Uint8List.view(buf.buffer, offset),
      );
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<List<int>, List<Condition>> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterSequenceUInt32.write(
        entry.key,
        Uint8List.view(buf.buffer, offset),
      );
      offset += FfiConverterSequenceCondition.write(
        entry.value,
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<List<int>, List<Condition>> value) {
    return value.entries
        .map(
          (e) =>
              FfiConverterSequenceUInt32.allocationSize(e.key) +
              FfiConverterSequenceCondition.allocationSize(e.value),
        )
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<List<int>, List<Condition>> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceUInt32 {
  static List<int> lift(RustBuffer buf) {
    return FfiConverterSequenceUInt32.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<int>> read(Uint8List buf) {
    List<int> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterUInt32.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<int> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterUInt32.write(
        value[i],
        Uint8List.view(buf.buffer, offset),
      );
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<int> value) {
    return value
            .map((l) => FfiConverterUInt32.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<int> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

const int UNIFFI_RUST_FUTURE_POLL_READY = 0;
const int UNIFFI_RUST_FUTURE_POLL_MAYBE_READY = 1;
typedef UniffiRustFutureContinuationCallback = Void Function(Uint64, Int8);
Future<T> uniffiRustCallAsync<T, F>(
  Pointer<Void> Function() rustFutureFunc,
  void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
  pollFunc,
  F Function(Pointer<Void>, Pointer<RustCallStatus>) completeFunc,
  void Function(Pointer<Void>) freeFunc,
  T Function(F) liftFunc, [
  UniffiRustCallStatusErrorHandler? errorHandler,
]) async {
  final rustFuture = rustFutureFunc();
  final completer = Completer<int>();
  late final NativeCallable<UniffiRustFutureContinuationCallback> callback;
  void poll() {
    pollFunc(rustFuture, callback.nativeFunction, Pointer<Void>.fromAddress(0));
  }

  void onResponse(int _idx, int pollResult) {
    if (pollResult == UNIFFI_RUST_FUTURE_POLL_READY) {
      completer.complete(pollResult);
    } else {
      poll();
    }
  }

  callback = NativeCallable<UniffiRustFutureContinuationCallback>.listener(
    onResponse,
  );
  try {
    poll();
    await completer.future;
    callback.close();
    final status = calloc<RustCallStatus>();
    try {
      final result = completeFunc(rustFuture, status);
      return liftFunc(result);
    } finally {
      calloc.free(status);
    }
  } finally {
    freeFunc(rustFuture);
  }
}

class UniffiHandleMap<T> {
  final Map<int, T> _map = {};
  int _counter = 1;
  int insert(T obj) {
    final handle = _counter;
    _counter += 2;
    _map[handle] = obj;
    return handle;
  }

  T get(int handle) {
    final obj = _map[handle];
    if (obj == null) {
      throw UniffiInternalError(
        UniffiInternalError.unexpectedStaleHandle,
        "Handle not found",
      );
    }
    return obj;
  }

  void remove(int handle) {
    if (_map.remove(handle) == null) {
      throw UniffiInternalError(
        UniffiInternalError.unexpectedStaleHandle,
        "Handle not found",
      );
    }
  }
}

const _uniffiAssetId = "package:bdk_dart/uniffi:bdk_ffi";
@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_address(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_address(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_address_from_script(
  Pointer<Void> script,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(RustBuffer, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_address_new(
  RustBuffer address,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_address_is_valid_for_network(
  Pointer<Void> ptr,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_address_script_pubkey(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_address_to_address_data(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_address_to_qr_uri(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_address_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_address_uniffi_trait_eq_eq(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_address_uniffi_trait_eq_ne(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_amount(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_amount(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Double, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_amount_from_btc(
  double btc,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_amount_from_sat(
  int satoshi,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Double Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external double uniffi_bdk_ffi_fn_method_amount_to_btc(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_amount_to_sat(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_blockhash(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_blockhash(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_blockhash_from_bytes(
  RustBuffer bytes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_blockhash_from_string(
  RustBuffer hex,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_blockhash_serialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_blockhash_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_blockhash_uniffi_trait_eq_eq(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_blockhash_uniffi_trait_eq_ne(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_blockhash_uniffi_trait_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_blockhash_uniffi_trait_ord_cmp(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_bumpfeetxbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_bumpfeetxbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_bumpfeetxbuilder_new(
  Pointer<Void> txid,
  Pointer<Void> fee_rate,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Int8, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_allow_dust(
  Pointer<Void> ptr,
  int allow_dust,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Uint32, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_current_height(
  Pointer<Void> ptr,
  int height,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_finish(
  Pointer<Void> ptr,
  Pointer<Void> wallet,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_nlocktime(
  Pointer<Void> ptr,
  RustBuffer locktime,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Uint32, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_set_exact_sequence(
  Pointer<Void> ptr,
  int nsequence,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_bumpfeetxbuilder_version(
  Pointer<Void> ptr,
  int version,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_cbfbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_cbfbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_cbfbuilder_new(
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_cbfbuilder_build(
  Pointer<Void> ptr,
  Pointer<Void> wallet,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Uint64, Uint64, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_method_cbfbuilder_configure_timeout_millis(
  Pointer<Void> ptr,
  int handshake,
  int response,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Uint8, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfbuilder_connections(
  Pointer<Void> ptr,
  int connections,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfbuilder_data_dir(
  Pointer<Void> ptr,
  RustBuffer data_dir,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfbuilder_peers(
  Pointer<Void> ptr,
  RustBuffer peers,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfbuilder_scan_type(
  Pointer<Void> ptr,
  RustBuffer scan_type,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfbuilder_socks5_proxy(
  Pointer<Void> ptr,
  RustBuffer proxy,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_cbfclient(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_cbfclient(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<Void>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfclient_average_fee_rate(
  Pointer<Void> ptr,
  Pointer<Void> blockhash,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<Void>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfclient_broadcast(
  Pointer<Void> ptr,
  Pointer<Void> transaction,
);

@Native<Void Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_cbfclient_connect(
  Pointer<Void> ptr,
  RustBuffer peer,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_cbfclient_is_running(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_cbfclient_lookup_host(
  Pointer<Void> ptr,
  RustBuffer hostname,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfclient_min_broadcast_feerate(
  Pointer<Void> ptr,
);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfclient_next_info(
  Pointer<Void> ptr,
);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfclient_next_warning(
  Pointer<Void> ptr,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_cbfclient_shutdown(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_cbfclient_update(
  Pointer<Void> ptr,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_cbfnode(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_cbfnode(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_cbfnode_run(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_changeset(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_changeset(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    RustBuffer,
    RustBuffer,
    RustBuffer,
    RustBuffer,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_changeset_from_aggregate(
  RustBuffer descriptor,
  RustBuffer change_descriptor,
  RustBuffer network,
  RustBuffer local_chain,
  RustBuffer tx_graph,
  RustBuffer indexer,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    RustBuffer,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_changeset_from_descriptor_and_network(
  RustBuffer descriptor,
  RustBuffer change_descriptor,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_changeset_from_indexer_changeset(
  RustBuffer indexer_changes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_changeset_from_local_chain_changes(
  RustBuffer local_chain_changes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_changeset_from_merge(
  Pointer<Void> left,
  Pointer<Void> right,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_changeset_from_tx_graph_changeset(
  RustBuffer tx_graph_changeset,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_changeset_new(
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_changeset_change_descriptor(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_changeset_descriptor(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_changeset_indexer_changeset(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_changeset_localchain_changeset(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_changeset_network(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_changeset_tx_graph_changeset(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_derivationpath(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_derivationpath(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_derivationpath_master(
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_derivationpath_new(
  RustBuffer path,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_derivationpath_is_empty(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_derivationpath_is_master(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_derivationpath_len(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer
uniffi_bdk_ffi_fn_method_derivationpath_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_descriptor(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_descriptor(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(RustBuffer, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_descriptor_new(
  RustBuffer descriptor,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_descriptor_new_bip44(
  Pointer<Void> secret_key,
  RustBuffer keychain_kind,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_descriptor_new_bip44_public(
  Pointer<Void> public_key,
  RustBuffer fingerprint,
  RustBuffer keychain_kind,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_descriptor_new_bip49(
  Pointer<Void> secret_key,
  RustBuffer keychain_kind,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_descriptor_new_bip49_public(
  Pointer<Void> public_key,
  RustBuffer fingerprint,
  RustBuffer keychain_kind,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_descriptor_new_bip84(
  Pointer<Void> secret_key,
  RustBuffer keychain_kind,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_descriptor_new_bip84_public(
  Pointer<Void> public_key,
  RustBuffer fingerprint,
  RustBuffer keychain_kind,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_descriptor_new_bip86(
  Pointer<Void> secret_key,
  RustBuffer keychain_kind,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_descriptor_new_bip86_public(
  Pointer<Void> public_key,
  RustBuffer fingerprint,
  RustBuffer keychain_kind,
  RustBuffer network,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_descriptor_desc_type(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_descriptor_descriptor_id(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_descriptor_is_multipath(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_descriptor_max_weight_to_satisfy(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_descriptor_to_single_descriptors(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_descriptor_to_string_with_secret(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_descriptor_uniffi_trait_debug(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_descriptor_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_descriptorid(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_descriptorid(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_descriptorid_from_bytes(
  RustBuffer bytes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_descriptorid_from_string(
  RustBuffer hex,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_descriptorid_serialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_descriptorid_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_descriptorid_uniffi_trait_eq_eq(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_descriptorid_uniffi_trait_eq_ne(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_descriptorid_uniffi_trait_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_descriptorid_uniffi_trait_ord_cmp(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_descriptorpublickey(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_descriptorpublickey(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_descriptorpublickey_from_string(
  RustBuffer public_key,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_descriptorpublickey_derive(
  Pointer<Void> ptr,
  Pointer<Void> path,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_descriptorpublickey_extend(
  Pointer<Void> ptr,
  Pointer<Void> path,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_descriptorpublickey_is_multipath(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer
uniffi_bdk_ffi_fn_method_descriptorpublickey_master_fingerprint(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer
uniffi_bdk_ffi_fn_method_descriptorpublickey_uniffi_trait_debug(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer
uniffi_bdk_ffi_fn_method_descriptorpublickey_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_descriptorsecretkey(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_descriptorsecretkey(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_descriptorsecretkey_from_string(
  RustBuffer private_key,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    RustBuffer,
    Pointer<Void>,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_descriptorsecretkey_new(
  RustBuffer network,
  Pointer<Void> mnemonic,
  RustBuffer password,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_descriptorsecretkey_as_public(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_descriptorsecretkey_derive(
  Pointer<Void> ptr,
  Pointer<Void> path,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_descriptorsecretkey_extend(
  Pointer<Void> ptr,
  Pointer<Void> path,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_descriptorsecretkey_secret_bytes(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer
uniffi_bdk_ffi_fn_method_descriptorsecretkey_uniffi_trait_debug(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer
uniffi_bdk_ffi_fn_method_descriptorsecretkey_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_electrumclient(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_electrumclient(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(RustBuffer, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_electrumclient_new(
  RustBuffer url,
  RustBuffer socks5,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer
uniffi_bdk_ffi_fn_method_electrumclient_block_headers_subscribe(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Double Function(Pointer<Void>, Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external double uniffi_bdk_ffi_fn_method_electrumclient_estimate_fee(
  Pointer<Void> ptr,
  int number,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    Uint64,
    Uint64,
    Int8,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_electrumclient_full_scan(
  Pointer<Void> ptr,
  Pointer<Void> request,
  int stop_gap,
  int batch_size,
  int fetch_prev_txouts,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_electrumclient_ping(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_electrumclient_server_features(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    Uint64,
    Int8,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_electrumclient_sync(
  Pointer<Void> ptr,
  Pointer<Void> request,
  int batch_size,
  int fetch_prev_txouts,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_method_electrumclient_transaction_broadcast(
  Pointer<Void> ptr,
  Pointer<Void> tx,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_esploraclient(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_esploraclient(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(RustBuffer, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_esploraclient_new(
  RustBuffer url,
  RustBuffer proxy,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_esploraclient_broadcast(
  Pointer<Void> ptr,
  Pointer<Void> transaction,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    Uint64,
    Uint64,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_esploraclient_full_scan(
  Pointer<Void> ptr,
  Pointer<Void> request,
  int stop_gap,
  int parallel_requests,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Uint32, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_esploraclient_get_block_hash(
  Pointer<Void> ptr,
  int block_height,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_esploraclient_get_fee_estimates(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_esploraclient_get_height(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_esploraclient_get_tx(
  Pointer<Void> ptr,
  Pointer<Void> txid,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_esploraclient_get_tx_info(
  Pointer<Void> ptr,
  Pointer<Void> txid,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_esploraclient_get_tx_status(
  Pointer<Void> ptr,
  Pointer<Void> txid,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    Uint64,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_esploraclient_sync(
  Pointer<Void> ptr,
  Pointer<Void> request,
  int parallel_requests,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_feerate(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_feerate(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_feerate_from_sat_per_kwu(
  int sat_kwu,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_feerate_from_sat_per_vb(
  int sat_vb,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_feerate_fee_vb(
  Pointer<Void> ptr,
  int vb,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_feerate_fee_wu(
  Pointer<Void> ptr,
  int wu,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_feerate_to_sat_per_kwu(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_feerate_to_sat_per_vb_ceil(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_feerate_to_sat_per_vb_floor(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_feerate_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_fullscanrequest(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_fullscanrequest(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_fullscanrequestbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_fullscanrequestbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_fullscanrequestbuilder_build(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_method_fullscanrequestbuilder_inspect_spks_for_all_keychains(
  Pointer<Void> ptr,
  Pointer<Void> inspector,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_fullscanscriptinspector(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_fullscanscriptinspector(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(Pointer<UniffiVTableCallbackInterfaceFullScanScriptInspector>)
>(assetId: _uniffiAssetId)
external void uniffi_bdk_ffi_fn_init_callback_vtable_fullscanscriptinspector(
  Pointer<UniffiVTableCallbackInterfaceFullScanScriptInspector> vtable,
);

@Native<
  Void Function(
    Pointer<Void>,
    RustBuffer,
    Uint32,
    Pointer<Void>,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external void uniffi_bdk_ffi_fn_method_fullscanscriptinspector_inspect(
  Pointer<Void> ptr,
  RustBuffer keychain,
  int index,
  Pointer<Void> script,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_hashableoutpoint(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_hashableoutpoint(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_hashableoutpoint_new(
  RustBuffer outpoint,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_hashableoutpoint_outpoint(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer
uniffi_bdk_ffi_fn_method_hashableoutpoint_uniffi_trait_debug(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_hashableoutpoint_uniffi_trait_eq_eq(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_hashableoutpoint_uniffi_trait_eq_ne(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_hashableoutpoint_uniffi_trait_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_ipaddress(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_ipaddress(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Uint8, Uint8, Uint8, Uint8, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_ipaddress_from_ipv4(
  int q1,
  int q2,
  int q3,
  int q4,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Uint16,
    Uint16,
    Uint16,
    Uint16,
    Uint16,
    Uint16,
    Uint16,
    Uint16,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_ipaddress_from_ipv6(
  int a,
  int b,
  int c,
  int d,
  int e,
  int f,
  int g,
  int h,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_leafnode(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_leafnode(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_leafnode_depth(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_leafnode_leaf_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_leafnode_leaf_version(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_leafnode_merkle_branch(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_leafnode_node_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_leafnode_script(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_leafnode_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_mnemonic(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_mnemonic(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_mnemonic_from_entropy(
  RustBuffer entropy,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_mnemonic_from_string(
  RustBuffer mnemonic,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_mnemonic_new(
  RustBuffer word_count,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_mnemonic_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_nodeinfo(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_nodeinfo(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_nodeinfo_leaf_nodes(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_nodeinfo_node_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_nodeinfo_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_persistence(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_persistence(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<UniffiVTableCallbackInterfacePersistence>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_init_callback_vtable_persistence(
  Pointer<UniffiVTableCallbackInterfacePersistence> vtable,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_persistence_initialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_persistence_persist(
  Pointer<Void> ptr,
  Pointer<Void> changeset,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_persister(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_persister(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_persister_custom(
  Pointer<Void> persistence,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_persister_new_in_memory(
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_persister_new_sqlite(
  RustBuffer path,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_policy(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_policy(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_policy_as_string(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_policy_contribution(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_policy_id(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_policy_item(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_policy_requires_path(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_policy_satisfaction(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_psbt(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_psbt(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_psbt_from_file(
  RustBuffer path,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_psbt_from_unsigned_tx(
  Pointer<Void> tx,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_psbt_new(
  RustBuffer psbt_base64,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_psbt_combine(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_psbt_extract_tx(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_psbt_fee(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_psbt_finalize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_psbt_input(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_psbt_json_serialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_psbt_output(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_psbt_serialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_psbt_spend_utxo(
  Pointer<Void> ptr,
  int input_index,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_psbt_write_to_file(
  Pointer<Void> ptr,
  RustBuffer path,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_script(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_script(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_script_new(
  RustBuffer raw_output_script,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_script_to_bytes(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_script_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_syncrequest(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_syncrequest(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_syncrequestbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_syncrequestbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_syncrequestbuilder_build(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_syncrequestbuilder_inspect_spks(
  Pointer<Void> ptr,
  Pointer<Void> inspector,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_syncscriptinspector(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_syncscriptinspector(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(Pointer<UniffiVTableCallbackInterfaceSyncScriptInspector>)
>(assetId: _uniffiAssetId)
external void uniffi_bdk_ffi_fn_init_callback_vtable_syncscriptinspector(
  Pointer<UniffiVTableCallbackInterfaceSyncScriptInspector> vtable,
);

@Native<
  Void Function(Pointer<Void>, Pointer<Void>, Uint64, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external void uniffi_bdk_ffi_fn_method_syncscriptinspector_inspect(
  Pointer<Void> ptr,
  Pointer<Void> script,
  int total,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_taptree(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_taptree(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_taptree_node_info(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_taptree_root_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_taptree_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_transaction(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_transaction(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_transaction_new(
  RustBuffer transaction_bytes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_transaction_compute_txid(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_transaction_compute_wtxid(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_transaction_input(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_is_coinbase(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_is_explicitly_rbf(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_is_lock_time_enabled(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_lock_time(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_transaction_output(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_transaction_serialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_total_size(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_version(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_vsize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_weight(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_transaction_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_uniffi_trait_eq_eq(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_transaction_uniffi_trait_eq_ne(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_txbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_txbuilder(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_txbuilder_new(
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_add_data(
  Pointer<Void> ptr,
  RustBuffer data,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_add_global_xpubs(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    Pointer<Void>,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_add_recipient(
  Pointer<Void> ptr,
  Pointer<Void> script,
  Pointer<Void> amount,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_add_unspendable(
  Pointer<Void> ptr,
  RustBuffer unspendable,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_add_utxo(
  Pointer<Void> ptr,
  RustBuffer outpoint,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_add_utxos(
  Pointer<Void> ptr,
  RustBuffer outpoints,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Int8, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_allow_dust(
  Pointer<Void> ptr,
  int allow_dust,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_change_policy(
  Pointer<Void> ptr,
  RustBuffer change_policy,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Uint32, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_current_height(
  Pointer<Void> ptr,
  int height,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_do_not_spend_change(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_drain_to(
  Pointer<Void> ptr,
  Pointer<Void> script,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_drain_wallet(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Uint32, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_method_txbuilder_exclude_below_confirmations(
  Pointer<Void> ptr,
  int min_confirms,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_exclude_unconfirmed(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_fee_absolute(
  Pointer<Void> ptr,
  Pointer<Void> fee_amount,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_fee_rate(
  Pointer<Void> ptr,
  Pointer<Void> fee_rate,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_finish(
  Pointer<Void> ptr,
  Pointer<Void> wallet,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_method_txbuilder_manually_selected_only(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_nlocktime(
  Pointer<Void> ptr,
  RustBuffer locktime,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_only_spend_change(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_policy_path(
  Pointer<Void> ptr,
  RustBuffer policy_path,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Uint32, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_set_exact_sequence(
  Pointer<Void> ptr,
  int nsequence,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_set_recipients(
  Pointer<Void> ptr,
  RustBuffer recipients,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_unspendable(
  Pointer<Void> ptr,
  RustBuffer unspendable,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Int32, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_txbuilder_version(
  Pointer<Void> ptr,
  int version,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_txmerklenode(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_txmerklenode(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_txmerklenode_from_bytes(
  RustBuffer bytes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_txmerklenode_from_string(
  RustBuffer hex,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_txmerklenode_serialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_txmerklenode_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_txmerklenode_uniffi_trait_eq_eq(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_txmerklenode_uniffi_trait_eq_ne(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_txmerklenode_uniffi_trait_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_txmerklenode_uniffi_trait_ord_cmp(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_txid(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_txid(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_txid_from_bytes(
  RustBuffer bytes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_txid_from_string(
  RustBuffer hex,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_txid_serialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_txid_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_txid_uniffi_trait_eq_eq(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_txid_uniffi_trait_eq_ne(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_txid_uniffi_trait_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_txid_uniffi_trait_ord_cmp(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_update(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_update(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_wallet(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_wallet(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    Pointer<Void>,
    Uint32,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void>
uniffi_bdk_ffi_fn_constructor_wallet_create_from_two_path_descriptor(
  Pointer<Void> two_path_descriptor,
  RustBuffer network,
  Pointer<Void> persister,
  int lookahead,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    RustBuffer,
    Pointer<Void>,
    Uint32,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_wallet_create_single(
  Pointer<Void> descriptor,
  RustBuffer network,
  Pointer<Void> persister,
  int lookahead,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    Pointer<Void>,
    Uint32,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_wallet_load(
  Pointer<Void> descriptor,
  Pointer<Void> change_descriptor,
  Pointer<Void> persister,
  int lookahead,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    Uint32,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_wallet_load_single(
  Pointer<Void> descriptor,
  Pointer<Void> persister,
  int lookahead,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(
    Pointer<Void>,
    Pointer<Void>,
    RustBuffer,
    Pointer<Void>,
    Uint32,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_wallet_new(
  Pointer<Void> descriptor,
  Pointer<Void> change_descriptor,
  RustBuffer network,
  Pointer<Void> persister,
  int lookahead,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_wallet_apply_evicted_txs(
  Pointer<Void> ptr,
  RustBuffer evicted_txs,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_wallet_apply_unconfirmed_txs(
  Pointer<Void> ptr,
  RustBuffer unconfirmed_txs,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_wallet_apply_update(
  Pointer<Void> ptr,
  Pointer<Void> update,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_apply_update_events(
  Pointer<Void> ptr,
  Pointer<Void> update,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_balance(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_wallet_calculate_fee(
  Pointer<Void> ptr,
  Pointer<Void> tx,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Pointer<Void> Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_bdk_ffi_fn_method_wallet_calculate_fee_rate(
  Pointer<Void> ptr,
  Pointer<Void> tx,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_method_wallet_cancel_tx(
  Pointer<Void> ptr,
  Pointer<Void> tx,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_derivation_index(
  Pointer<Void> ptr,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_derivation_of_spk(
  Pointer<Void> ptr,
  Pointer<Void> spk,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_descriptor_checksum(
  Pointer<Void> ptr,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Int8 Function(
    Pointer<Void>,
    Pointer<Void>,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_fn_method_wallet_finalize_psbt(
  Pointer<Void> ptr,
  Pointer<Void> psbt,
  RustBuffer sign_options,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_get_tx(
  Pointer<Void> ptr,
  Pointer<Void> txid,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_get_utxo(
  Pointer<Void> ptr,
  RustBuffer op,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(Pointer<Void>, RustBuffer, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external void uniffi_bdk_ffi_fn_method_wallet_insert_txout(
  Pointer<Void> ptr,
  RustBuffer outpoint,
  RustBuffer txout,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_wallet_is_mine(
  Pointer<Void> ptr,
  Pointer<Void> script,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_latest_checkpoint(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_list_output(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_list_unspent(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_list_unused_addresses(
  Pointer<Void> ptr,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Int8 Function(Pointer<Void>, RustBuffer, Uint32, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_fn_method_wallet_mark_used(
  Pointer<Void> ptr,
  RustBuffer keychain,
  int index,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_network(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint32 Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_wallet_next_derivation_index(
  Pointer<Void> ptr,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_next_unused_address(
  Pointer<Void> ptr,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(
    Pointer<Void>,
    RustBuffer,
    Uint32,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_peek_address(
  Pointer<Void> ptr,
  RustBuffer keychain,
  int index,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_wallet_persist(
  Pointer<Void> ptr,
  Pointer<Void> persister,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_policies(
  Pointer<Void> ptr,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_public_descriptor(
  Pointer<Void> ptr,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(
    Pointer<Void>,
    RustBuffer,
    Uint32,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_reveal_addresses_to(
  Pointer<Void> ptr,
  RustBuffer keychain,
  int index,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, RustBuffer, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_reveal_next_address(
  Pointer<Void> ptr,
  RustBuffer keychain,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_sent_and_received(
  Pointer<Void> ptr,
  Pointer<Void> tx,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Int8 Function(
    Pointer<Void>,
    Pointer<Void>,
    RustBuffer,
    Pointer<RustCallStatus>,
  )
>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_fn_method_wallet_sign(
  Pointer<Void> ptr,
  Pointer<Void> psbt,
  RustBuffer sign_options,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_staged(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_method_wallet_start_full_scan(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void>
uniffi_bdk_ffi_fn_method_wallet_start_sync_with_revealed_spks(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_take_staged(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_transactions(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  RustBuffer Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external RustBuffer uniffi_bdk_ffi_fn_method_wallet_tx_details(
  Pointer<Void> ptr,
  Pointer<Void> txid,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Int8 Function(Pointer<Void>, RustBuffer, Uint32, Pointer<RustCallStatus>)
>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_fn_method_wallet_unmark_used(
  Pointer<Void> ptr,
  RustBuffer keychain,
  int index,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_clone_wtxid(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void uniffi_bdk_ffi_fn_free_wtxid(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_wtxid_from_bytes(
  RustBuffer bytes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external Pointer<Void> uniffi_bdk_ffi_fn_constructor_wtxid_from_string(
  RustBuffer hex,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wtxid_serialize(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_wtxid_uniffi_trait_display(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_wtxid_uniffi_trait_eq_eq(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_wtxid_uniffi_trait_eq_ne(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_wtxid_uniffi_trait_hash(
  Pointer<Void> ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Int8 Function(Pointer<Void>, Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int uniffi_bdk_ffi_fn_method_wtxid_uniffi_trait_ord_cmp(
  Pointer<Void> ptr,
  Pointer<Void> other,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_walletevent_uniffi_trait_display(
  RustBuffer ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer uniffi_bdk_ffi_fn_method_conflict_uniffi_trait_display(
  RustBuffer ptr,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer ffi_bdk_ffi_rustbuffer_alloc(
  int size,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(ForeignBytes, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer ffi_bdk_ffi_rustbuffer_from_bytes(
  ForeignBytes bytes,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Void Function(RustBuffer, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void ffi_bdk_ffi_rustbuffer_free(
  RustBuffer buf,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<RustBuffer Function(RustBuffer, Uint64, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer ffi_bdk_ffi_rustbuffer_reserve(
  RustBuffer buf,
  int additional,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_u8(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_u8(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_u8(Pointer<Void> handle);

@Native<Uint8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int ffi_bdk_ffi_rust_future_complete_u8(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_i8(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_i8(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_i8(Pointer<Void> handle);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int ffi_bdk_ffi_rust_future_complete_i8(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_u16(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_u16(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_u16(Pointer<Void> handle);

@Native<Uint16 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int ffi_bdk_ffi_rust_future_complete_u16(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_i16(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_i16(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_i16(Pointer<Void> handle);

@Native<Int16 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int ffi_bdk_ffi_rust_future_complete_i16(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_u32(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_u32(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_u32(Pointer<Void> handle);

@Native<Uint32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int ffi_bdk_ffi_rust_future_complete_u32(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_i32(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_i32(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_i32(Pointer<Void> handle);

@Native<Int32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int ffi_bdk_ffi_rust_future_complete_i32(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_u64(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_u64(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_u64(Pointer<Void> handle);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int ffi_bdk_ffi_rust_future_complete_u64(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_i64(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_i64(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_i64(Pointer<Void> handle);

@Native<Int64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external int ffi_bdk_ffi_rust_future_complete_i64(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_f32(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_f32(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_f32(Pointer<Void> handle);

@Native<Float Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external double ffi_bdk_ffi_rust_future_complete_f32(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_f64(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_f64(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_f64(Pointer<Void> handle);

@Native<Double Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external double ffi_bdk_ffi_rust_future_complete_f64(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_rust_buffer(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_rust_buffer(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_rust_buffer(Pointer<Void> handle);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external RustBuffer ffi_bdk_ffi_rust_future_complete_rust_buffer(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<
  Void Function(
    Pointer<Void>,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
    Pointer<Void>,
  )
>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_poll_void(
  Pointer<Void> handle,
  Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
  Pointer<Void> callback_data,
);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_cancel_void(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_bdk_ffi_rust_future_free_void(Pointer<Void> handle);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
  assetId: _uniffiAssetId,
)
external void ffi_bdk_ffi_rust_future_complete_void(
  Pointer<Void> handle,
  Pointer<RustCallStatus> uniffiStatus,
);

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_address_is_valid_for_network();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_address_script_pubkey();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_address_to_address_data();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_address_to_qr_uri();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_amount_to_btc();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_amount_to_sat();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_blockhash_serialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_allow_dust();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_current_height();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_finish();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_nlocktime();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_set_exact_sequence();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_version();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfbuilder_build();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_method_cbfbuilder_configure_timeout_millis();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfbuilder_connections();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfbuilder_data_dir();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfbuilder_peers();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfbuilder_scan_type();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfbuilder_socks5_proxy();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_average_fee_rate();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_broadcast();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_connect();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_is_running();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_lookup_host();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_min_broadcast_feerate();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_next_info();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_next_warning();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_shutdown();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfclient_update();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_cbfnode_run();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_changeset_change_descriptor();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_changeset_descriptor();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_changeset_indexer_changeset();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_changeset_localchain_changeset();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_changeset_network();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_changeset_tx_graph_changeset();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_derivationpath_is_empty();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_derivationpath_is_master();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_derivationpath_len();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptor_desc_type();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptor_descriptor_id();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptor_is_multipath();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptor_max_weight_to_satisfy();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptor_to_single_descriptors();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptor_to_string_with_secret();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptorid_serialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptorpublickey_derive();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptorpublickey_extend();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptorpublickey_is_multipath();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_method_descriptorpublickey_master_fingerprint();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptorsecretkey_as_public();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptorsecretkey_derive();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptorsecretkey_extend();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_descriptorsecretkey_secret_bytes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_method_electrumclient_block_headers_subscribe();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_electrumclient_estimate_fee();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_electrumclient_full_scan();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_electrumclient_ping();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_electrumclient_server_features();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_electrumclient_sync();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_method_electrumclient_transaction_broadcast();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_broadcast();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_full_scan();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_get_block_hash();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_get_fee_estimates();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_get_height();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_get_tx();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_get_tx_info();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_get_tx_status();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_esploraclient_sync();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_feerate_fee_vb();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_feerate_fee_wu();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_feerate_to_sat_per_kwu();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_feerate_to_sat_per_vb_ceil();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_feerate_to_sat_per_vb_floor();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_fullscanrequestbuilder_build();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_method_fullscanrequestbuilder_inspect_spks_for_all_keychains();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_fullscanscriptinspector_inspect();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_hashableoutpoint_outpoint();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_leafnode_depth();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_leafnode_leaf_hash();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_leafnode_leaf_version();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_leafnode_merkle_branch();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_leafnode_node_hash();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_leafnode_script();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_nodeinfo_leaf_nodes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_nodeinfo_node_hash();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_persistence_initialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_persistence_persist();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_policy_as_string();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_policy_contribution();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_policy_id();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_policy_item();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_policy_requires_path();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_policy_satisfaction();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_combine();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_extract_tx();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_fee();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_finalize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_input();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_json_serialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_output();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_serialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_spend_utxo();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_psbt_write_to_file();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_script_to_bytes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_syncrequestbuilder_build();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_syncrequestbuilder_inspect_spks();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_syncscriptinspector_inspect();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_taptree_node_info();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_taptree_root_hash();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_compute_txid();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_compute_wtxid();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_input();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_is_coinbase();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_is_explicitly_rbf();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_is_lock_time_enabled();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_lock_time();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_output();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_serialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_total_size();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_version();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_vsize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_transaction_weight();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_add_data();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_add_global_xpubs();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_add_recipient();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_add_unspendable();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_add_utxo();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_add_utxos();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_allow_dust();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_change_policy();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_current_height();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_do_not_spend_change();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_drain_to();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_drain_wallet();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_method_txbuilder_exclude_below_confirmations();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_exclude_unconfirmed();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_fee_absolute();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_fee_rate();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_finish();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_manually_selected_only();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_nlocktime();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_only_spend_change();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_policy_path();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_set_exact_sequence();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_set_recipients();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_unspendable();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txbuilder_version();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txmerklenode_serialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_txid_serialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_apply_evicted_txs();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_apply_unconfirmed_txs();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_apply_update();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_apply_update_events();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_balance();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_calculate_fee();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_calculate_fee_rate();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_cancel_tx();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_derivation_index();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_derivation_of_spk();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_descriptor_checksum();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_finalize_psbt();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_get_tx();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_get_utxo();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_insert_txout();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_is_mine();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_latest_checkpoint();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_list_output();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_list_unspent();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_list_unused_addresses();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_mark_used();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_network();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_next_derivation_index();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_next_unused_address();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_peek_address();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_persist();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_policies();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_public_descriptor();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_reveal_addresses_to();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_reveal_next_address();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_sent_and_received();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_sign();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_staged();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_start_full_scan();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_method_wallet_start_sync_with_revealed_spks();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_take_staged();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_transactions();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_tx_details();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wallet_unmark_used();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_method_wtxid_serialize();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_address_from_script();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_address_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_amount_from_btc();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_amount_from_sat();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_blockhash_from_bytes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_blockhash_from_string();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_bumpfeetxbuilder_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_cbfbuilder_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_changeset_from_aggregate();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_constructor_changeset_from_descriptor_and_network();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_constructor_changeset_from_indexer_changeset();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_constructor_changeset_from_local_chain_changes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_changeset_from_merge();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_constructor_changeset_from_tx_graph_changeset();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_changeset_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_derivationpath_master();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_derivationpath_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip44();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip44_public();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip49();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip49_public();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip84();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip84_public();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip86();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip86_public();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptorid_from_bytes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptorid_from_string();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_constructor_descriptorpublickey_from_string();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_constructor_descriptorsecretkey_from_string();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_descriptorsecretkey_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_electrumclient_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_esploraclient_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_feerate_from_sat_per_kwu();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_feerate_from_sat_per_vb();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_hashableoutpoint_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_ipaddress_from_ipv4();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_ipaddress_from_ipv6();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_mnemonic_from_entropy();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_mnemonic_from_string();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_mnemonic_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_persister_custom();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_persister_new_in_memory();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_persister_new_sqlite();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_psbt_from_file();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_psbt_from_unsigned_tx();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_psbt_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_script_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_transaction_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_txbuilder_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_txmerklenode_from_bytes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_txmerklenode_from_string();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_txid_from_bytes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_txid_from_string();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
uniffi_bdk_ffi_checksum_constructor_wallet_create_from_two_path_descriptor();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_wallet_create_single();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_wallet_load();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_wallet_load_single();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_wallet_new();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_wtxid_from_bytes();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_bdk_ffi_checksum_constructor_wtxid_from_string();

@Native<Uint32 Function()>(assetId: _uniffiAssetId)
external int ffi_bdk_ffi_uniffi_contract_version();

void _checkApiVersion() {
  final bindingsVersion = 30;
  final scaffoldingVersion = ffi_bdk_ffi_uniffi_contract_version();
  if (bindingsVersion != scaffoldingVersion) {
    throw UniffiInternalError.panicked(
      "UniFFI contract version mismatch: bindings version \$bindingsVersion, scaffolding version \$scaffoldingVersion",
    );
  }
}

void _checkApiChecksums() {
  if (uniffi_bdk_ffi_checksum_method_address_is_valid_for_network() != 58834) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_address_script_pubkey() != 6492) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_address_to_address_data() != 47484) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_address_to_qr_uri() != 52985) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_amount_to_btc() != 64424) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_amount_to_sat() != 31792) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_blockhash_serialize() != 32449) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_allow_dust() != 12923) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_current_height() !=
      7758) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_finish() != 12165) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_nlocktime() != 59890) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_set_exact_sequence() !=
      64283) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_bumpfeetxbuilder_version() != 6860) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfbuilder_build() != 8770) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfbuilder_configure_timeout_millis() !=
      17634) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfbuilder_connections() != 6011) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfbuilder_data_dir() != 20215) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfbuilder_peers() != 55620) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfbuilder_scan_type() != 59906) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfbuilder_socks5_proxy() != 54084) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_average_fee_rate() != 1878) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_broadcast() != 40093) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_connect() != 8651) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_is_running() != 36862) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_lookup_host() != 38279) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_min_broadcast_feerate() !=
      44424) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_next_info() != 37639) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_next_warning() != 50627) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_shutdown() != 2636) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfclient_update() != 47432) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_cbfnode_run() != 38486) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_changeset_change_descriptor() != 17621) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_changeset_descriptor() != 5023) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_changeset_indexer_changeset() != 30454) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_changeset_localchain_changeset() !=
      51162) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_changeset_network() != 45541) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_changeset_tx_graph_changeset() != 53854) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_derivationpath_is_empty() != 3986) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_derivationpath_is_master() != 19617) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_derivationpath_len() != 28121) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptor_desc_type() != 58900) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptor_descriptor_id() != 38146) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptor_is_multipath() != 21030) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptor_max_weight_to_satisfy() !=
      17346) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptor_to_single_descriptors() !=
      17090) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptor_to_string_with_secret() !=
      8784) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorid_serialize() != 2747) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorpublickey_derive() != 37477) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorpublickey_extend() != 58762) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorpublickey_is_multipath() !=
      4579) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorpublickey_master_fingerprint() !=
      51355) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorsecretkey_as_public() != 8511) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorsecretkey_derive() != 16347) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorsecretkey_extend() != 55133) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_descriptorsecretkey_secret_bytes() !=
      16565) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_electrumclient_block_headers_subscribe() !=
      15719) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_electrumclient_estimate_fee() != 2683) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_electrumclient_full_scan() != 30842) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_electrumclient_ping() != 61668) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_electrumclient_server_features() !=
      41743) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_electrumclient_sync() != 11118) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_electrumclient_transaction_broadcast() !=
      26614) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_broadcast() != 54246) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_full_scan() != 53805) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_get_block_hash() != 37103) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_get_fee_estimates() !=
      42504) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_get_height() != 18107) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_get_tx() != 48382) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_get_tx_info() != 22272) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_get_tx_status() != 21863) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_esploraclient_sync() != 36366) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_feerate_fee_vb() != 32527) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_feerate_fee_wu() != 44005) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_feerate_to_sat_per_kwu() != 25467) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_feerate_to_sat_per_vb_ceil() != 50163) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_feerate_to_sat_per_vb_floor() != 59137) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_fullscanrequestbuilder_build() != 65268) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_fullscanrequestbuilder_inspect_spks_for_all_keychains() !=
      11482) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_fullscanscriptinspector_inspect() !=
      40482) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_hashableoutpoint_outpoint() != 4424) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_leafnode_depth() != 53733) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_leafnode_leaf_hash() != 43032) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_leafnode_leaf_version() != 8207) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_leafnode_merkle_branch() != 63181) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_leafnode_node_hash() != 4592) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_leafnode_script() != 3198) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_nodeinfo_leaf_nodes() != 8604) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_nodeinfo_node_hash() != 13774) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_persistence_initialize() != 37215) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_persistence_persist() != 21226) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_policy_as_string() != 46589) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_policy_contribution() != 57429) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_policy_id() != 38100) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_policy_item() != 42710) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_policy_requires_path() != 18313) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_policy_satisfaction() != 1276) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_combine() != 27079) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_extract_tx() != 43213) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_fee() != 53973) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_finalize() != 36345) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_input() != 49394) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_json_serialize() != 36223) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_output() != 20297) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_serialize() != 13370) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_spend_utxo() != 38830) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_psbt_write_to_file() != 17778) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_script_to_bytes() != 48556) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_syncrequestbuilder_build() != 15665) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_syncrequestbuilder_inspect_spks() !=
      40632) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_syncscriptinspector_inspect() != 22632) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_taptree_node_info() != 35322) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_taptree_root_hash() != 46565) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_compute_txid() != 8292) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_compute_wtxid() != 7392) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_input() != 44057) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_is_coinbase() != 14764) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_is_explicitly_rbf() != 39504) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_is_lock_time_enabled() !=
      18938) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_lock_time() != 59770) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_output() != 19078) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_serialize() != 37460) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_total_size() != 52740) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_version() != 9035) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_vsize() != 33645) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_transaction_weight() != 16184) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_add_data() != 61325) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_add_global_xpubs() != 38250) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_add_recipient() != 5503) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_add_unspendable() != 64023) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_add_utxo() != 44072) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_add_utxos() != 34042) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_allow_dust() != 2598) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_change_policy() != 16899) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_current_height() != 36023) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_do_not_spend_change() != 13237) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_drain_to() != 28724) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_drain_wallet() != 12155) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_exclude_below_confirmations() !=
      16889) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_exclude_unconfirmed() != 22626) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_fee_absolute() != 64438) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_fee_rate() != 41179) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_finish() != 20400) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_manually_selected_only() !=
      3419) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_nlocktime() != 64019) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_only_spend_change() != 48921) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_policy_path() != 45225) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_set_exact_sequence() != 26020) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_set_recipients() != 42923) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_unspendable() != 37752) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txbuilder_version() != 56620) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txmerklenode_serialize() != 55458) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_txid_serialize() != 34368) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_apply_evicted_txs() != 38613) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_apply_unconfirmed_txs() != 36047) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_apply_update() != 21985) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_apply_update_events() != 8925) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_balance() != 40623) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_calculate_fee() != 58614) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_calculate_fee_rate() != 23595) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_cancel_tx() != 62653) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_derivation_index() != 12147) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_derivation_of_spk() != 33890) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_descriptor_checksum() != 16571) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_finalize_psbt() != 47196) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_get_tx() != 11548) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_get_utxo() != 50480) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_insert_txout() != 43418) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_is_mine() != 34050) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_latest_checkpoint() != 39027) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_list_output() != 35853) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_list_unspent() != 39350) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_list_unused_addresses() != 36825) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_mark_used() != 31695) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_network() != 45497) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_next_derivation_index() != 48019) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_next_unused_address() != 59238) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_peek_address() != 47237) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_persist() != 38195) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_policies() != 1627) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_public_descriptor() != 46409) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_reveal_addresses_to() != 26974) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_reveal_next_address() != 59794) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_sent_and_received() != 64344) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_sign() != 38758) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_staged() != 53622) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_start_full_scan() != 49663) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_start_sync_with_revealed_spks() !=
      37953) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_take_staged() != 53866) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_transactions() != 39233) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_tx_details() != 63343) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wallet_unmark_used() != 12388) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_method_wtxid_serialize() != 11692) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_address_from_script() != 53873) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_address_new() != 15043) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_amount_from_btc() != 23325) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_amount_from_sat() != 17199) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_blockhash_from_bytes() != 27411) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_blockhash_from_string() != 62285) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_bumpfeetxbuilder_new() != 61384) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_cbfbuilder_new() != 15933) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_changeset_from_aggregate() != 57192) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_changeset_from_descriptor_and_network() !=
      50900) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_changeset_from_indexer_changeset() !=
      9631) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_changeset_from_local_chain_changes() !=
      2667) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_changeset_from_merge() != 43851) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_changeset_from_tx_graph_changeset() !=
      22890) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_changeset_new() != 56637) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_derivationpath_master() != 6600) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_derivationpath_new() != 34456) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new() != 27373) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip44() != 38441) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip44_public() !=
      31976) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip49() != 21710) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip49_public() !=
      33058) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip84() != 31499) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip84_public() !=
      6369) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip86() != 8889) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptor_new_bip86_public() !=
      25176) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptorid_from_bytes() != 30517) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptorid_from_string() != 5253) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptorpublickey_from_string() !=
      15349) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptorsecretkey_from_string() !=
      9449) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_descriptorsecretkey_new() != 21450) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_electrumclient_new() != 31738) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_esploraclient_new() != 58792) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_feerate_from_sat_per_kwu() != 33221) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_feerate_from_sat_per_vb() != 20574) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_hashableoutpoint_new() != 47084) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_ipaddress_from_ipv4() != 45725) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_ipaddress_from_ipv6() != 37730) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_mnemonic_from_entropy() != 49307) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_mnemonic_from_string() != 6308) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_mnemonic_new() != 55849) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_persister_custom() != 46513) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_persister_new_in_memory() != 30307) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_persister_new_sqlite() != 24754) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_psbt_from_file() != 20679) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_psbt_from_unsigned_tx() != 32825) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_psbt_new() != 22484) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_script_new() != 36422) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_transaction_new() != 55676) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_txbuilder_new() != 13310) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_txmerklenode_from_bytes() != 11813) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_txmerklenode_from_string() != 48702) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_txid_from_bytes() != 31263) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_txid_from_string() != 10387) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_wallet_create_from_two_path_descriptor() !=
      51041) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_wallet_create_single() != 12991) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_wallet_load() != 62118) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_wallet_load_single() != 26442) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_wallet_new() != 42446) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_wtxid_from_bytes() != 30088) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_bdk_ffi_checksum_constructor_wtxid_from_string() != 30209) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
}

void ensureInitialized() {
  _checkApiVersion();
  _checkApiChecksums();
}
