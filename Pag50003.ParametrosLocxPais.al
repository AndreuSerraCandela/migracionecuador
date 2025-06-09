page 50003 "Parametros Loc. x Pais"
{
    ApplicationArea = All;
    Caption = 'Parametros Loc. x Pais';
    PageType = List;
    SourceTable = "Parametros Loc. x País";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cantidad Lin. por factura"; Rec."Cantidad Lin. por factura")
                {
                    ToolTip = 'Specifies the value of the Line Qty. per Invoice field.', Comment = '%';
                }
                field("Caption AFP"; Rec."Caption AFP")
                {
                    ToolTip = 'Specifies the value of the Caption AFP field.', Comment = '%';
                }
                field("Caption Depto"; Rec."Caption Depto")
                {
                    ToolTip = 'Specifies the value of the Caption Depto field.', Comment = '%';
                }
                field("Caption INFOTEP"; Rec."Caption INFOTEP")
                {
                    ToolTip = 'Specifies the value of the Caption INFOTEP field.', Comment = '%';
                }
                field("Caption ISR"; Rec."Caption ISR")
                {
                    ToolTip = 'Specifies the value of the Caption ISR field.', Comment = '%';
                }
                field("Caption SFS"; Rec."Caption SFS")
                {
                    ToolTip = 'Specifies the value of the Caption SFS field.', Comment = '%';
                }
                field("Caption SRL"; Rec."Caption SRL")
                {
                    ToolTip = 'Specifies the value of the Caption SRL field.', Comment = '%';
                }
                field("Caption Sub Depto"; Rec."Caption Sub Depto")
                {
                    ToolTip = 'Specifies the value of the Caption Sub Depto field.', Comment = '%';
                }
                field("Control Lin. por Factura"; Rec."Control Lin. por Factura")
                {
                    ToolTip = 'Specifies the value of the Control Lines per Invoice field.', Comment = '%';
                }
                field("Formato Doc. Vtas. por cliente"; Rec."Formato Doc. Vtas. por cliente")
                {
                    ToolTip = 'Specifies the value of the Sales documents format by customer field.', Comment = '%';
                }
                field("NCF Activado"; Rec."NCF Activado")
                {
                    ToolTip = 'Specifies the value of the NCF Activated field.', Comment = '%';
                }
                field("País"; Rec."País")
                {
                    ToolTip = 'Specifies the value of the Country field.', Comment = '%';
                }
                field("Re facturacion"; Rec."Re facturacion")
                {
                    ToolTip = 'Specifies the value of the Re Invoicing field.', Comment = '%';
                }
            }
        }
    }
}
