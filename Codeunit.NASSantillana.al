codeunit 56002 "NAS  - Santillana"
{

    trigger OnRun()
    begin
        RunCostAdjmt;
        UpdateDim;
    end;


    procedure RunCostAdjmt()
    begin
        //MESSAGE('Iniciando Ajuste de costos %1',TIME);
        REPORT.RunModal(REPORT::"Adjust Cost - Item Ent. - NAS", false, false);
        REPORT.RunModal(REPORT::"Post Inventory Cost to G/L_NAS", false, false);

        //MESSAGE('Fin Ajuste de costos %1',TIME);
    end;


    procedure UpdateDim()
    var
        cuDim: Codeunit "Update Analysis View";
    begin
        //MESSAGE('Iniciando proceso dimensiones %1',TIME);
        //cuDim.UpdateAll(2,FALSE);
        //MESSAGE('Fin proceso dimensiones %1',TIME);
    end;
}

