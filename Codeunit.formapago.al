codeunit 56013 "forma pago"
{

    trigger OnRun()
    var
        vendor: Record Vendor;
    begin
        if not Confirm(CompanyName) then exit;
        vendor.ModifyAll("Payment Method Code", 'CHEQUE');
        Message('FIN');
    end;
}

