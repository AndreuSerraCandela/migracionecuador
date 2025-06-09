codeunit 55004 "Barcode 128"
{

    trigger OnRun()
    begin
    end;

    var
        C128Bars: array[107] of Text[13];


    procedure C128MakeBarcode(BarcodeText: Text[250]; var Pic: Record "Company Information"; C128PicWidth: Integer; C128PicHeight: Integer; C128PicDPI: Integer; C128PlacePicRight: Boolean)
    var
        OStrm: OutStream;
        cWhite: Char;
        cBlack: Char;
        CharCode: Integer;
        Line: Integer;
        i: Integer;
        j: Integer;
        Modules: Integer;
        BMPLines: Integer;
        BarcodeTextLen: Integer;
        WhiteSpaces: Integer;
        Standard128BEN: Label ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~', Locked = true;
        Standard128BDE: Label ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ^_`abcdefghijklmnopqrstuvwxyzäöüß', Locked = true;
        Standard128B: Label ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ^_`abcdefghijklmnopqrstuvwxyzäöüß', Locked = true;
        C128Checksum: Integer;
    begin
        // Generate Barcode as Code128B as a BMP in a temporary BLOB
        // (C) 2009 by Wolfram Ansin (w.ansin at dsm.ag)
        // Version 1.0
        // based on a idea and program code of Robert de Bath (http://www.tvisiontech.co.uk/)
        // You can use and modify this code for free if you show Robert's and my name.
        // Code is provided without any warranty, use at your own risk.
        // programed with Navision 2.6 german

        // usage: C128MakeBarcode(Barcodetext, Pic, PicWidth, PicHeight, PicDPI, PlacePicRight)
        // Barcodetext: the readable text to make a barcode without checksumcharacter
        // Pic: the Record which has a BLOB called Bild; in Bild ist the resulting BMP stored
        // (Bild is german; the english translation is picture; maybe you have to change this in Navision 3.x and up)
        // C128PicWidth: the maximum width of the generated picture
        // C128PicHeight: the maximum height of the generated picture
        // C128PicDPI: the maximum size of the bars depend on the DPI; higher DPI = smaler bars;
        //             normally use 48dpi or 96dpi
        // C128PlacePicRight: place a small barcode on the left (false) or right (true) side

        // If Barcodetable is not filled, initialize Barcodetable
        if C128Bars[1] = '' then
            C128BcodeTab();

        cWhite := 255;
        cBlack := 0;

        BarcodeTextLen := StrLen(BarcodeText);

        // 1 module is the smalest object of a barcode, a small white or black bar;
        // a thick bar consists of more than 1 module (e.g. 2 or 3 or 4 ...)
        // Modules = how much modules are needed for the complete barcode
        // Code128: BarcodeTextLen + 3 = complete barcode incl. start-, check- und stop-character
        //          11 modules per character (eexcept for stop: stop has 2 modules more = 13)
        //          no gaps between the bars of 2 characters
        Modules := (BarcodeTextLen + 3) * 11 + 2; // Code128

        // BMPLines = number of lines in barcode-picture, because ResX and ResY in DPI are the same in the picture
        BMPLines := Round(Modules * 0.15, 1, '>');

        // check if resulting bars are too wide with the given DPI and PicWidth
        // if yes, calculate the white space at the right (or left)
        if (C128PicWidth <> 0) and (C128PicDPI <> 0) then begin
            WhiteSpaces := Round(C128PicWidth / 2540 * C128PicDPI, 1, '>') - Modules;
            // Whitespaces = (minimum number of modules) - nedded modules
            if WhiteSpaces < 0 then
                WhiteSpaces := 0;
        end else // no information about the BMP
            WhiteSpaces := 0;

        // Allocate the needed memory, otherwise the generating of large barcode may take a very long time
        Pic.Picture.CreateOutStream(OStrm);
        // Allocate memory in kbyte:
        // (Modules + Whitespaces) * Lines * 3 (3 byte per pixel, 24bpp) / 1024 (for kByte)
        for i := 1 to Round((WhiteSpaces + Modules) * BMPLines * 3 / 1024, 1, '>') do
            OStrm.WriteText(PadStr('', 1023, ' ')); // 1023 plus a NUL = 1024

        // open the Stream again to start from the beginning
        Pic.Picture.CreateOutStream(OStrm);

        C128WriteBMPHeader(OStrm, (Modules + WhiteSpaces), BMPLines, C128PicWidth, C128PicHeight, C128PicDPI);
        // (Stream, Cols, Rows, Width, Height, DPI)

        for Line := 1 to BMPLines do begin
            // if barcode-picture should placed on the right, fill with white space now (if needed)
            if (C128PlacePicRight = true) and (WhiteSpaces > 0) then
                for i := 1 to (WhiteSpaces * 3) do
                    OStrm.Write(cWhite, 1);

            C128WriteBarcode(OStrm, 105); // 105 = StartB = Start barcode with Code128B
            C128Checksum := (105 - 1); // Startcodevalue is 105-1 = 104
            for i := 1 to BarcodeTextLen do begin // analyze barcodetext and generate bars
                CharCode := StrPos(Standard128B, Format(BarcodeText[i])); // which number has the actual charater
                                                                          // in Standard128xx are all valid characters as a constant string at the correct position
                if CharCode = 0 then // invalid character
                    CharCode := 1;     // replace invalid with space
                C128Checksum += i * (CharCode - 1); // Value for checksum is 1 less than position at the constant string
                C128WriteBarcode(OStrm, CharCode);
            end; // all characters of the barcodetext convertet to bars

            // checksum-character
            C128Checksum := C128Checksum mod 103;
            C128WriteBarcode(OStrm, C128Checksum + 1); // +1 because of 1-based-array

            // Stop-Character
            C128WriteBarcode(OStrm, 106 + 1); // 106 is code for stopcharacter; has 13 modules

            // if barcode is to small for PicWidth, fill with white space on the right (if not filled on the left)
            if (C128PlacePicRight = false) and (WhiteSpaces > 0) then
                for i := 1 to (WhiteSpaces * 3) do
                    OStrm.Write(cWhite, 1);

            // check if number of bytes is a multiple of 4 (because of BMP);
            // * 3 because each pixel needs 3 colorbytes (24bpp)
            j := (Modules + WhiteSpaces) * 3;
            if j <> Round(j, 4, '>') then
                for i := j + 1 to Round(j, 4, '>') do
                    OStrm.Write(cWhite, 1); // fill with white

        end; // next BMP-Line
    end;


    procedure C128WriteBarcode(Strm: OutStream; C128ID: Integer)
    var
        j: Integer;
        ch: Byte;
        BarcodeString: Text[20];
        intPrueba: Integer;
    begin
        // Generate the bars for a given charater-number
        BarcodeString := C128Bars[C128ID]; // in BarcodeString is now the coding in bars of the given value
        for j := 1 to StrLen(BarcodeString) do begin // STRLEN(BC) is not fixed, it is 11 or 13 (13 for stopchar)
            if BarcodeString[j] = 'b' then
                ch := 0     // black
            else
                ch := 255;  // white
            Strm.Write(ch, 1);
            Strm.Write(ch, 1);
            Strm.Write(ch, 1); // write module; 3 byte = 1 pixel (24bpp)
        end;
    end;

    local procedure C128WriteBMPHeader(Strm: OutStream; Cols: Integer; Rows: Integer; Width: Integer; Height: Integer; DPI: Integer)
    var
        ch: Char;
        ResX: Integer;
        ResY: Integer;
        BMPSize: Integer;
    begin
        // Write BMP-Header
        // Don't touch this code - it only works with this code (I don't know why)
        if DPI > 0 then begin
            ResX := Round(39.37 * DPI, 1);
            ResY := ResX;
            if Width > 0 then
                ResX := Round(Cols / Width * 100000, 1);
            if Height > 0 then
                ResY := Round(Rows / Height * 100000, 1);
        end else
            if (Width > 0) and (Height > 0) then begin
                ResX := Round(Cols / Width * 100000, 1);
                ResY := Round(Rows / Height * 100000, 1);
            end;

        // BMP File Header (14 byte)
        // Magic signs 'BM' (2 byte)
        ch := 'B';
        Strm.Write(ch, 1);
        ch := 'M';
        Strm.Write(ch, 1);
        // BMP file size (4 byte)
        BMPSize := 54 +           // Header
        Round((Rows * 3), 4, '>') // Pixel per Line, per pixel 3 byte, a multiple of 4
         * Cols;                  // Lines
        Strm.Write(BMPSize, 4);
        // Reserved (4 byte, must be zero)
        Strm.Write(0, 4);
        // Offset of bitmap from begining of file
        Strm.Write(54, 4);
        // End BMP Fileheader

        // Start of Bitmap-Infoheader (40 byte)
        Strm.Write(40, 4);          // Bytes in Header (40) (4 byte)
        Strm.Write(Cols, 4);        // Weight in pixel (4 byte); If not divisible by four padding is required.
        Strm.Write(Rows, 4);        // Height in pixel (4 byte); positive = bottom-up, negative = top-down (in theory; doesn't work).
        //Strm.WRITE(01, 2);          // must be 1 (2 byte); does not work
        //Strm.WRITE(24, 2);          // bpp (2 byte); does not work
        Strm.Write(65536 * 24 + 1); // only this way works (24bpp, +1)
        Strm.Write(0, 4);           // Compression: no (4 byte)
        Strm.Write(0, 4);           // Raw bitmap size (4 byte) (0=default for uncompressed)
        Strm.Write(ResX, 4);        // Pixels/metre Horizontal, dpm = 39.370 * dpi, screen = 96dpi (3780)
        Strm.Write(ResY, 4);        // Pixels/metre Vertical
        Strm.Write(0, 4);           // Colours in palette (0=no palette)
        Strm.Write(0, 4);           // Important colours, ignored.
        // End of Bitmap-Infoheader

        // Bytes BGR (Yes, BGR and not RGB!)
        // Line per Line
        // every line must be filled with NUL to a multiple of 4
    end;

    local procedure C128BcodeTab()
    begin
        // Table with the bars for a character
        // Code128 has 11 modules for each charater (except STOP)
        //                12345678901, b = black, w = white.
        // Code128C (numeric)
        //    Code128B (alphaumeric)
        //      Code128A (only if different form Code128B)
        C128Bars[1] := 'bbwbbwwbbww'; // 00 (blank)
        C128Bars[2] := 'bbwwbbwbbww'; // 01 !
        C128Bars[3] := 'bbwwbbwwbbw'; // 02 "
        C128Bars[4] := 'bwwbwwbbwww'; // 03 #
        C128Bars[5] := 'bwwbwwwbbww'; // 04 $
        C128Bars[6] := 'bwwwbwwbbww'; // 05 %
        C128Bars[7] := 'bwwbbwwbwww'; // 06 &
        C128Bars[8] := 'bwwbbwwwbww'; // 07 '
        C128Bars[9] := 'bwwwbbwwbww'; // 08 (
        C128Bars[10] := 'bbwwbwwbwww'; // 09 )
        C128Bars[11] := 'bbwwbwwwbww'; // 10 *
        C128Bars[12] := 'bbwwwbwwbww'; // 11 +
        C128Bars[13] := 'bwbbwwbbbww'; // 12 ,
        C128Bars[14] := 'bwwbbwbbbww'; // 13 -
        C128Bars[15] := 'bwwbbwwbbbw'; // 14 .
        C128Bars[16] := 'bwbbbwwbbww'; // 15 /
        C128Bars[17] := 'bwwbbbwbbww'; // 16 0
        C128Bars[18] := 'bwwbbbwwbbw'; // 17 1
        C128Bars[19] := 'bbwwbbbwwbw'; // 18 2
        C128Bars[20] := 'bbwwbwbbbww'; // 19 3
        C128Bars[21] := 'bbwwbwwbbbw'; // 20 4
        C128Bars[22] := 'bbwbbbwwbww'; // 21 5
        C128Bars[23] := 'bbwwbbbwbww'; // 22 6
        C128Bars[24] := 'bbbwbbwbbbw'; // 23 7
        C128Bars[25] := 'bbbwbwwbbww'; // 24 8
        C128Bars[26] := 'bbbwwbwbbww'; // 25 9
        C128Bars[27] := 'bbbwwbwwbbw'; // 26 :
        C128Bars[28] := 'bbbwbbwwbww'; // 27 ;
        C128Bars[29] := 'bbbwwbbwbww'; // 28 <
        C128Bars[30] := 'bbbwwbbwwbw'; // 29 =
        C128Bars[31] := 'bbwbbwbbwww'; // 30 >
        C128Bars[32] := 'bbwbbwwwbbw'; // 31 ?
        C128Bars[33] := 'bbwwwbbwbbw'; // 32 @
        C128Bars[34] := 'bwbwwwbbwww'; // 33 A
        C128Bars[35] := 'bwwwbwbbwww'; // 34 B
        C128Bars[36] := 'bwwwbwwwbbw'; // 35 C
        C128Bars[37] := 'bwbbwwwbwww'; // 36 D
        C128Bars[38] := 'bwwwbbwbwww'; // 37 E
        C128Bars[39] := 'bwwwbbwwwbw'; // 38 F
        C128Bars[40] := 'bbwbwwwbwww'; // 39 G
        C128Bars[41] := 'bbwwwbwbwww'; // 40 H
        C128Bars[42] := 'bbwwwbwwwbw'; // 41 I
        C128Bars[43] := 'bwbbwbbbwww'; // 42 J
        C128Bars[44] := 'bwbbwwwbbbw'; // 43 K
        C128Bars[45] := 'bwwwbbwbbbw'; // 44 L
        C128Bars[46] := 'bwbbbwbbwww'; // 45 M
        C128Bars[47] := 'bwbbbwwwbbw'; // 46 N
        C128Bars[48] := 'bwwwbbbwbbw'; // 47 O
        C128Bars[49] := 'bbbwbbbwbbw'; // 48 P
        C128Bars[50] := 'bbwbwwwbbbw'; // 49 Q
        C128Bars[51] := 'bbwwwbwbbbw'; // 50 R
        C128Bars[52] := 'bbwbbbwbwww'; // 51 S
        C128Bars[53] := 'bbwbbbwwwbw'; // 52 T
        C128Bars[54] := 'bbwbbbwbbbw'; // 53 U
        C128Bars[55] := 'bbbwbwbbwww'; // 54 V
        C128Bars[56] := 'bbbwbwwwbbw'; // 55 W
        C128Bars[57] := 'bbbwwwbwbbw'; // 56 X
        C128Bars[58] := 'bbbwbbwbwww'; // 57 Y
        C128Bars[59] := 'bbbwbbwwwbw'; // 58 Z
        C128Bars[60] := 'bbbwwwbbwbw'; // 59 [
        C128Bars[61] := 'bbbwbbbbwbw'; // 60 \
        C128Bars[62] := 'bbwwbwwwwbw'; // 61 ]
        C128Bars[63] := 'bbbbwwwbwbw'; // 62 ^
        C128Bars[64] := 'bwbwwbbwwww'; // 63 _
        C128Bars[65] := 'bwbwwwwbbww'; // 64 ` NUL
        C128Bars[66] := 'bwwbwbbwwww'; // 65 a SOH
        C128Bars[67] := 'bwwbwwwwbbw'; // 66 b STX
        C128Bars[68] := 'bwwwwbwbbww'; // 67 c ETX
        C128Bars[69] := 'bwwwwbwwbbw'; // 68 d EOT
        C128Bars[70] := 'bwbbwwbwwww'; // 69 e ENQ
        C128Bars[71] := 'bwbbwwwwbww'; // 70 f ACK
        C128Bars[72] := 'bwwbbwbwwww'; // 71 g BEL
        C128Bars[73] := 'bwwbbwwwwbw'; // 72 h BS
        C128Bars[74] := 'bwwwwbbwbww'; // 73 i HT
        C128Bars[75] := 'bwwwwbbwwbw'; // 74 j LF
        C128Bars[76] := 'bbwwwwbwwbw'; // 75 k VT
        C128Bars[77] := 'bbwwbwbwwww'; // 76 l FF
        C128Bars[78] := 'bbbbwbbbwbw'; // 77 m CR
        C128Bars[79] := 'bbwwwwbwbww'; // 78 n SO
        C128Bars[80] := 'bwwwbbbbwbw'; // 79 o SI
        C128Bars[81] := 'bwbwwbbbbww'; // 80 p DLE
        C128Bars[82] := 'bwwbwbbbbww'; // 81 q DC1
        C128Bars[83] := 'bwwbwwbbbbw'; // 82 r DC2
        C128Bars[84] := 'bwbbbbwwbww'; // 83 s DC3
        C128Bars[85] := 'bwwbbbbwbww'; // 84 t DC4
        C128Bars[86] := 'bwwbbbbwwbw'; // 85 u NAK
        C128Bars[87] := 'bbbbwbwwbww'; // 86 v SYN
        C128Bars[88] := 'bbbbwwbwbww'; // 87 w ETB
        C128Bars[89] := 'bbbbwwbwwbw'; // 88 x CAN
        C128Bars[90] := 'bbwbbwbbbbw'; // 89 y EM
        C128Bars[91] := 'bbwbbbbwbbw'; // 90 z SUB
        C128Bars[92] := 'bbbbwbbwbbw'; // 91 { ESC
        C128Bars[93] := 'bwbwbbbbwww'; // 92 | FS
        C128Bars[94] := 'bwbwwwbbbbw'; // 93 } GS
        C128Bars[95] := 'bwwwbwbbbbw'; // 94 ~ RS
        C128Bars[96] := 'bwbbbbwbwww'; // 95 del US
        C128Bars[97] := 'bwbbbbwwwbw'; // 96 func3
        C128Bars[98] := 'bbbbwbwbwww'; // 97 func2
        C128Bars[99] := 'bbbbwbwwwbw'; // 98 shift
        C128Bars[100] := 'bwbbbwbbbbw'; // 99 CodeC
        C128Bars[101] := 'bwbbbbwbbbw'; // CodeB func4 CodeB
        C128Bars[102] := 'bbbwbwbbbbw'; // CodeA CodeA
        C128Bars[103] := 'bbbbwbwbbbw'; // func1 func1
        C128Bars[104] := 'bbwbwwwwbww'; // StartA StartA
        C128Bars[105] := 'bbwbwwbwwww'; // StartB StartB
        C128Bars[106] := 'bbwbwwbbbww'; // StartC StartC
        C128Bars[107] := 'bbwwwbbbwbwbb'; // Stop Stop
    end;
}

