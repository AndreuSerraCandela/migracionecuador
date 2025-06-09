codeunit 76005 "DSPayroll CaptionClass Mgmt"
{
    // Proyecto: Implementacion Microsoft Dynamics Nav
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roman
    // ------------------------------------------------------------------------
    // No.         Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // DSNOM1.03   27/08/2021      GRN           Modificaciones para manejar el caption de algunos campos
    // 
    // Caption conceptos salariales '4,4,x'
    // Caption maestro empleados '4,1,x'

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        CountyTxt: Label 'State';

    [EventSubscriber(ObjectType::Codeunit, 42, 'OnResolveCaptionClass', '', true, true)]
    local procedure ResolveCaptionClass(CaptionArea: Text; CaptionExpr: Text; Language: Integer; var Caption: Text; var Resolved: Boolean)
    begin
        if CaptionArea = '4' then begin
            Caption := PayrollClassTranslate(CaptionExpr);
            Resolved := true;
        end;
    end;

    local procedure PayrollClassTranslate(CaptionExpr: Text): Text
    var
        Configuracionnominas: Record "Configuracion nominas";
        CommaPosition: Integer;
        CaptionType: Text[30];
        CaptionRef: Text;
    begin
        if not Configuracionnominas.Get() then
            exit('');
        CommaPosition := StrPos(CaptionExpr, ',');
        if CommaPosition > 0 then begin
            CaptionType := CopyStr(CaptionExpr, 1, CommaPosition - 1);
            CaptionRef := CopyStr(CaptionExpr, CommaPosition + 1);
            case CaptionType of
                '1':
                    exit(Configuracionnominas."Caption Depto");
                '2':
                    exit(Configuracionnominas."Caption Sub Depto");
                '3':
                    exit(Configuracionnominas."Caption ISR");
                '4':
                    exit(Configuracionnominas."Caption AFP");
                '5':
                    exit(Configuracionnominas."Caption SFS");
                '6':
                    exit(Configuracionnominas."Caption INFOTEP");
                '7':
                    exit(Configuracionnominas."Caption SRL");
                else
                    exit(CaptionRef);
            end;
        end;
        exit(CountyTxt);
    end;
}

