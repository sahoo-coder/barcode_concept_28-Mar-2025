table 50800 "vendorAgingTable_KSS"
{
    DataClassification = ToBeClassified;
    Caption = 'Vendor_Aging_Table_KSS';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Before_Interval; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; first_interval; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; second_interval; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; third_interval; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}