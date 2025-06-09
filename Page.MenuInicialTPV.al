page 76076 "Menu Inicial TPV"
{
    ApplicationArea = all;
    // 
    // // Mejorar el buscar ventana ADdin inicial (Esta a piñon);
    // // Mejorar el teclado virtual para coger la distribución local (ya lo hace pero no coinciden los archivos);
    // // Comprobar instalación y autoregistrar ADDin automáticamente.
    // // Actualizaciones automáticas via FTP por version

    Caption = 'addin';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            /*             usercontrol(DSPoS; "DSPoS")
                        {
                        } */
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

        //fes mig CurrPage.DSPoS.DatosBD(cFuncDS.ServidorBBDD(1),cFuncDS.ServidorBBDD(0),COMPANYNAME);
    end;

    trigger OnOpenPage()
    begin

        AddInData := text001;
        cFuncDS.Comprobaciones_Iniciales;
    end;

    var
        AddInData: Text[1024];
        Err001: Label 'No puede cerrar esta página con el DSPoS iniciado';
        cFuncDS: Codeunit "Funciones Addin DSPos";
        text001: Label 'Copyright: DynaSoft Spain';
}

