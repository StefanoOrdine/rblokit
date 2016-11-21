require 'ffi'

module RbLoKit
  extend FFI::Library

  class LibreOfficeKitClass < FFI::Struct
  end

  class LibreOfficeKit < FFI::Struct
    layout :pClass, LibreOfficeKitClass.ptr
  end


  class LibreOfficeKitDocumentClass < FFI::Struct
  end

  class LibreOfficeKitDocument < FFI::Struct
    layout :pClass, LibreOfficeKitDocumentClass.ptr
  end

  class LibreOfficeKitDocumentClass < FFI::Struct
    layout :nSize, :size_t,
      :destroy, callback([LibreOfficeKitDocument.ptr], :void),
      :saveAs, callback([LibreOfficeKitDocument.ptr, :string, :string, :string], :int)
  end

  class LibreOfficeKitClass < FFI::Struct
    layout :nSize, :size_t,
      :destroy, callback([LibreOfficeKit.ptr], :void),
      :documentLoad, callback([LibreOfficeKit.ptr, :string], LibreOfficeKitDocument.ptr),
      :getError, callback([LibreOfficeKit.ptr], :string)
  end

  ffi_lib '/usr/lib/libreoffice/program/libmergedlo.so'
  attach_function :libreofficekit_hook, [:string], LibreOfficeKit.ptr
end

RbLoKit.libreofficekit_hook('/usr/lib/libreoffice/program/')

__END__

typedef struct _LibreOfficeKit LibreOfficeKit;
typedef struct _LibreOfficeKitClass LibreOfficeKitClass;
typedef struct _LibreOfficeKitDocument LibreOfficeKitDocument;
typedef struct _LibreOfficeKitDocumentClass LibreOfficeKitDocumentClass;
struct _LibreOfficeKit
{
    LibreOfficeKitClass* pClass;
};
struct _LibreOfficeKitClass
{
  size_t  nSize;
  void                    (*destroy)       (LibreOfficeKit *pThis);
  LibreOfficeKitDocument* (*documentLoad)  (LibreOfficeKit *pThis, const char *pURL);
  char*                   (*getError)      (LibreOfficeKit *pThis);
};
struct _LibreOfficeKitDocument
{
    LibreOfficeKitDocumentClass* pClass;
};
struct _LibreOfficeKitDocumentClass
{
  size_t  nSize;
  void (*destroy)   (LibreOfficeKitDocument* pThis);
  int (*saveAs)     (LibreOfficeKitDocument* pThis,
                     const char *pUrl,
                     const char *pFormat,
                     const char *pFilterOptions);
};
LibreOfficeKit *libreofficekit_hook(const char* install_path);
