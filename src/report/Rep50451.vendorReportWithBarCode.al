report 50451 vendorReportWithBarCode
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './vendorReportWithBarCode.rdl';
    Caption = 'Vendor Barcode Report_KSS';

    dataset
    {
        dataitem(Vendor; Vendor)
        {

            dataitem(Integer; Integer)
            {
                column(Number; Number) { }
                column(Vendor_No_; Vendor."No.") { }
                column(Vendor_Phone_No_; Vendor."Phone No.") { }
                column(Primary_Contact_No_; Vendor."Primary Contact No.") { }
                column(Tax_Area_Code; Vendor."Tax Area Code") { }
                column(Contact; Vendor.Contact) { }
                column(barcodeNo; barcodeNo) { }
                column(barcodephoneNo; barcodephoneNo) { }
                column(barcodecontactNo; barcodecontactNo) { }
                column(barcodetaxCode; barcodetaxCode) { }
                column(barcodeContact; barcodeContact) { }

                trigger OnPreDataItem()
                begin
                    if total = 0 then begin
                        Error('Give Number of time you want to print.');
                    end
                    else
                        SetFilter(Number, '%1..%2', 1, total);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    BarCodePrinter();
                end;

            }
            trigger OnPreDataItem()
            begin
                if vendorNo = '' then begin
                    Error('Give Vendor Number Please.');
                end
                else
                    Vendor.SetRange("No.", vendorNo);
            end;
        }

    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(BarCode_Report_KSS)
                {
                    field(total; total)
                    {
                        Caption = 'No. of Time You want the Barcode';
                        ApplicationArea = All;
                    }
                    field(vendorNo; vendorNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor No.';
                        TableRelation = Vendor."No.";
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    procedure BarCodePrinter()
    var
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeString: Code[100];
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeString := Vendor."No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        barcodeNo := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);

        BarcodeString := '';
        BarcodeString := Vendor."Phone No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        barcodephoneNo := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);

        BarcodeString := '';
        BarcodeString := Vendor."Primary Contact No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        barcodecontactNo := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);

        BarcodeString := '';
        BarcodeString := Vendor."Tax Area Code";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        barcodetaxCode := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);

        BarcodeString := '';
        BarcodeString := Vendor.Contact;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        barcodeContact := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    var
        total: Integer;
        vendorNo: Code[30];
        barcodeNo: Text;
        barcodephoneNo: Text;
        barcodecontactNo: Text;
        barcodetaxCode: Text;
        barcodeContact: Text;

}