report 50450 salesInvoiceHeaderBarcode
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './salesInvoiceHeaderBarCode_KSS.rdl';
    Caption = 'Barcode_Report_KSS';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            column(No_; "No.") { }
            column(Due_Date; "Due Date") { }
            column(BarCode_Item_Number; BarcdItemNo) { }

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                BarCodeItemNo();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {

        }
    }
    procedure BarCodeItemNo()
    var
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeString: Code[20];
    begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
        BarcodeString := "Sales Invoice Header"."No.";
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        BarcdItemNo := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
    end;

    var
        BarcdItemNo: Text;
}