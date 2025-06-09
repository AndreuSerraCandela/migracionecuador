codeunit 76076 toni2
{

    trigger OnRun()
    begin


        rcab.Get('VFACTAMB14-000000571');
        rcab.Delete(false);

        rlin.SetRange("Document No.", 'VFACTAMB14-000000571');
        if rlin.FindSet then
            rlin.DeleteAll(false);

        rcab.Get('VFACTAMB14-000000572');
        rcab.Delete(false);

        rlin.SetRange("Document No.", 'VFACTAMB14-000000572');
        if rlin.FindSet then
            rlin.DeleteAll(false);

        rcab.Get('VFACTAMB14-000000575');
        rcab.Delete(false);

        rlin.SetRange("Document No.", 'VFACTAMB14-000000575');
        if rlin.FindSet then
            rlin.DeleteAll(false);
    end;

    var
        rcab: Record "Sales Invoice Header";
        rlin: Record "Sales Invoice Line";
}

