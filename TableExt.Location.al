tableextension 50019 tableextension50019 extends Location
{
    fields
    {
        modify(Name)
        {
            Description = '#56924';
        }
        modify("Directed Put-away and Pick")
        {
            Caption = 'Directed Put-away and Pick';
        }

        //Unsupported feature: Deletion (FieldCollection) on ""SAT State Code"(Field 27026)".


        //Unsupported feature: Deletion (FieldCollection) on ""SAT Municipality Code"(Field 27027)".


        //Unsupported feature: Deletion (FieldCollection) on ""SAT Locality Code"(Field 27028)".


        //Unsupported feature: Deletion (FieldCollection) on ""SAT Suburb ID"(Field 27029)".


        //Unsupported feature: Deletion (FieldCollection) on ""ID Ubicacion"(Field 27030)".

        field(50000; "Cod. Cliente"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(50001; "Cod. Sucursal"; Code[10])
        {
            Caption = 'Establishment Code';
            DataClassification = ToBeClassified;
        }
        field(50002; "Cod. Transportista"; Code[20])
        {
            Caption = 'Cód. Transportista';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-2647';
            TableRelation = "Shipping Agent".Code;
        }
        field(50250; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Tax Prod. Posting Group Cost';
            DataClassification = ToBeClassified;
            Description = 'ITBISCOSTO';
            TableRelation = "VAT Product Posting Group";
        }
        field(56000; "Packing requerido"; Boolean)
        {
            Caption = 'Packing Required';
            DataClassification = ToBeClassified;
        }
        field(56001; "Cant. Lineas a Man. Por dia"; Integer)
        {
            Caption = 'Qty. of lines to handle by day';
            DataClassification = ToBeClassified;
        }
        field(56002; "Aviso cuando resten"; Integer)
        {
            Caption = 'Notice when remain';
            DataClassification = ToBeClassified;
        }
        field(56012; Inactivo; Boolean)
        {
            Caption = 'Inactivo';
            DataClassification = ToBeClassified;
            Description = '#7314,#37937';

            trigger OnValidate()
            var
                lErrorPermiso: Label 'No dispone de los permisos necesarios para Activar/Desactivar el Almacen';
                lrProducto: Record Item;
                lErrorProducto: Label 'No es posible Inactivar el almacen debido a que el producto %1 tiene inventario.';
                UserSetUp: Record "User Setup";
            begin
                //+001
                //#7314:Inicio
                if not (UserSetUp.Get(UserId) and UserSetUp."Activa/Inactiva Maestros") then
                    Error(lErrorPermiso);
                //#7314:Final

                //#37937:Inicio
                lrProducto.Reset;
                if lrProducto.FindSet(false) then
                    repeat
                        lrProducto.SetFilter("Location Filter", Code);
                        lrProducto.CalcFields(lrProducto.Inventory);
                        if lrProducto.Inventory <> 0 then
                            Error(lErrorProducto, lrProducto."No.");
                    until lrProducto.Next = 0;
                //#37937:Fin
                //-001
            end;
        }
        field(56013; "ID Interface SIC"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'SIC-JERM';
        }
    }

    procedure GetBinCode(UseFlushingMethod: Boolean; FlushingMethod: Option Manual,Forward,Backward,"Pick + Forward","Pick + Backward"): Code[20]
    begin
        if not UseFlushingMethod then
            exit("From-Production Bin Code");

        case FlushingMethod of
            FlushingMethod::Manual,
          FlushingMethod::"Pick + Forward",
          FlushingMethod::"Pick + Backward":
                exit("To-Production Bin Code");
            FlushingMethod::Forward,
          FlushingMethod::Backward:
                exit("Open Shop Floor Bin Code");
        end;
    end;
}

