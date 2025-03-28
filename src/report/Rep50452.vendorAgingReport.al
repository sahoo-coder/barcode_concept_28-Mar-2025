report 50452 vendorAgingReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './vendorAgingReport.rdl';
    Caption = 'Vendor_Aging_Report_KSS';

    dataset
    {
        dataitem(vendorAgingTable_KSS; vendorAgingTable_KSS)
        {
            column(No_; "No.") { }
            column(Name; Name) { }
            column(Before_Interval; Before_Interval) { }
            column(first_interval; first_interval) { }
            column(second_interval; second_interval) { }
            column(third_interval; third_interval) { }
            column(intervalFieldOne; intervalFieldOne) { }
            column(intervalFieldTwo; intervalFieldTwo) { }
            column(intervalFieldThree; intervalFieldThree) { }
            trigger OnPreDataItem()
            var
                venRecord: Record Vendor;
                venLedEntry: Record "Vendor Ledger Entry";
                before: Decimal;
                intervalArray: array[3] of Decimal;
                looper: Integer;
                second_Date_Start: Date;
                store_date_started: Date;
            begin
                vendorAgingTable_KSS.Reset();
                vendorAgingTable_KSS.DeleteAll();
                if (Date_start <> 0D) and (month_interval <> 0) then begin
                    Date_start := DMY2Date(1, Date2DMY(Date_start, 2), Date2DMY(Date_start, 3));
                    store_date_started := Date_start;
                    if venRecord.FindSet() then
                        repeat
                            before := 0;
                            for looper := 1 to 3 do begin
                                intervalArray[looper] := 0;
                            end;
                            Date_start := store_date_started;
                            second_Date_Start := 0D;
                            venLedEntry.Reset();
                            venLedEntry.SetRange("Vendor No.", venRecord."No.");
                            venLedEntry.SetFilter("Due Date", '..%1', store_date_started);

                            if venLedEntry.FindSet() then begin
                                // Message('Data Found in Vendor Ledger Entry');
                                repeat
                                    venLedEntry.CalcFields("Remaining Amount");
                                    if venLedEntry."Remaining Amount" <> 0 then begin
                                        before += venLedEntry."Remaining Amount";
                                    end;
                                until venLedEntry.Next() = 0
                            end
                            else
                                Message('No Data Found in Ven Led Entry Before the Date');
                            for looper := 1 to 3 do begin
                                if looper <> 1 then begin
                                    Date_start := second_Date_Start + 1;
                                    second_Date_Start := DMY2DATE(1, DATE2DMY(Date_start, 2) + month_interval, DATE2DMY(Date_start, 3)) - 1;
                                    if (intervalFieldTwo = '') and (looper = 2) then begin
                                        intervalFieldTwo := Format(Date_start) + '-' + Format(second_Date_Start);
                                    end;

                                    if (intervalFieldThree = '') and (looper = 3) then begin
                                        intervalFieldThree := Format(Date_start) + '-' + Format(second_Date_Start);
                                    end;
                                end
                                else begin
                                    Date_start := DMY2Date(1, Date2DMY(Date_start, 2), Date2DMY(Date_start, 3));
                                    second_Date_Start := DMY2DATE(1, DATE2DMY(Date_start, 2) + month_interval, DATE2DMY(Date_start, 3)) - 1;
                                    if intervalFieldOne = '' then begin
                                        intervalFieldOne := Format(Date_start) + '-' + Format(second_Date_Start);
                                    end;
                                end;
                                venLedEntry.Reset();
                                venLedEntry.SetRange("Vendor No.", venRecord."No.");
                                venLedEntry.SetFilter("Due Date", '%1..%2', Date_start, second_Date_Start);

                                if venLedEntry.FindSet() then
                                    repeat
                                        venLedEntry.CalcFields("Remaining Amount");
                                        if venLedEntry."Remaining Amount" <> 0 then begin
                                            intervalArray[looper] += venLedEntry."Remaining Amount";
                                        end;
                                    until venLedEntry.Next() = 0;
                            end;
                            vendorAgingTable_KSS."No." := venRecord."No.";
                            vendorAgingTable_KSS.Name := venRecord.Name;
                            vendorAgingTable_KSS.Before_Interval := before;
                            vendorAgingTable_KSS.first_interval := intervalArray[1];
                            vendorAgingTable_KSS.second_interval := intervalArray[2];
                            vendorAgingTable_KSS.third_interval := intervalArray[3];
                            vendorAgingTable_KSS.Insert();

                        until venRecord.Next() = 0;
                end
                else
                    Error('Give Starting Date Please or Give Month Interval(Zero Not Allowed)');
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
                group("Print Aging_KSS")
                {
                    field(Date_start; Date_start)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                    }
                    field(month_interval; month_interval)
                    {
                        Caption = 'Enter Month Interval';
                        ApplicationArea = All;
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
    var
        Date_start: Date;
        month_interval: Integer;
        intervalFieldOne: Text;
        intervalFieldTwo: Text;
        intervalFieldThree: Text;
}