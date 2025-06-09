page 56040 "Seleccion periodo"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            field(wMes; wMes)
            {
                Caption = 'Ingrese Mes';
            }
            field(wAno; wAno)
            {
                Caption = 'Ingrese Año';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        wMes := Date2DMY(WorkDate, 2);
        wAno := Date2DMY(WorkDate, 3);
    end;

    var
        wMes: Integer;
        wAno: Integer;


    procedure EnviaDatos(var pMes: Integer; var pAno: Integer)
    var
        Err001: Label 'Debe ingresar el mes y el año.';
        Err002: Label 'Mes no válido.';
        Err003: Label 'Año no válido.';
    begin

        if ((wMes <> 0) and (wAno = 0)) or ((wMes = 0) and (wAno <> 0)) then
            Error(Err001);


        if (wMes < 1) or (wMes > 12) then
            Error(Err002);

        if wAno < 2000 then
            Error(Err003);

        pMes := wMes;
        pAno := wAno;
    end;
}

