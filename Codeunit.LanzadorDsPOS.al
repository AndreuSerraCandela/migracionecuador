codeunit 76046 "Lanzador DsPOS"
{

    trigger OnRun()
    var
        cfAddin: Codeunit "Funciones Addin DSPos";
        pPOS: Page "Menu Inicial TPV";
    begin


        Clear(cfAddin);
        cfAddin.RegistrarAddin();
        cfAddin.CrearAcciones();

        Clear(pPOS);
        Commit;
        pPOS.Run;
    end;
}

