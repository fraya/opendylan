Module:    Dylan-User
Synopsis:  The command line version of the environment
Author:    Andy Armstrong
Copyright:    Original Code is Copyright (c) 1995-2004 Functional Objects, Inc.
              All rights reserved.
License:      See License.txt in this distribution for details.
Warranty:     Distributed WITHOUT WARRANTY OF ANY KIND

define library dylan-environment
  use dylan;
  use common-dylan;
  use system;
  use io;
  use commands;

  use dfmc-common, import: { dfmc-common };
  use release-info;

  use environment-protocols;
  use environment-commands;
  use environment-application-commands;
  use environment-internal-commands;

  // Back-ends
  use dfmc-back-end-implementations;

  // Project manager plug-ins call tool-register on load.
  use motley;
  use protobuf-tool;
  use tool-scepter;
  use tool-parser-generator;

  // Plug-ins for debugging
  use local-access-path;
  use remote-access-path;

  export console-environment;
end library dylan-environment;
