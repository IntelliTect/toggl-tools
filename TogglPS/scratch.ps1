
  Id CommandLine                                                                                                                     
  -- -----------                                                                                                                     
   1 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
   2 $m3                                                                                                                             
   3 $me                                                                                                                             
   4 $m3.data                                                                                                                        
   5 $me.data                                                                                                                        
   6 $me.data.email                                                                                                                  
   7 $me.data.id                                                                                                                     
   8 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
   9 $projects                                                                                                                       
  10 $projects[0]                                                                                                                    
  11 $projects[0].name                                                                                                               
  12 $projects                                                                                                                       
  13 $projects | fl -Property Name                                                                                                   
  14 $projects | ft -Property Name                                                                                                   
  15 $projects | ft -Property id -Property Name                                                                                      
  16 $projects                                                                                                                       
  17 $projects | fl -Property id -Property Name                                                                                      
  18 $projects | fl -Property id, Name                                                                                               
  19 $projects | ft -Property id, Name                                                                                               
  20 Date                                                                                                                            
  21 Date.ToString()                                                                                                                 
  22 Date                                                                                                                            
  23 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  24 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  25 $timeEntry                                                                                                                      
  26 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  27 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  28 $headers                                                                                                                        
  29 $timeEntry                                                                                                                      
  30 $timeEntryDetails                                                                                                               
  31 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  32 $timeEntryDetails                                                                                                               
  33 Invoke-RestMethod -Uri $addTimeEntryUri -Method Post -Headers $headers                                                          
  34 Invoke-RestMethod -Uri $addTimeEntryUri -Method Post -Headers $headers -Body $timeEntry                                         
  35 Invoke-RestMethod -Uri $addTimeEntryUri -Method Post -Headers $headers -Body $timeEntry                                         
  36 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  37 $timeEntry | ConvertTo-Json                                                                                                     
  38 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  39 $projects                                                                                                                       
  40 $projects | fl -Property id, name                                                                                               
  41 $projects | ft -Property id, name                                                                                               
  42 $projects[0]                                                                                                                    
  43 $projects | ft -Property id, name                                                                                               
  44 Invoke-RestMethod -Uri $addTimeEntryUri -Method Post -Headers $headers -Body $timeEntry                                         
  45 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  46 $ws.id                                                                                                                          
  47 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  48 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  49 $projects | ft -Property id, name                                                                                               
  50 projects | where-object ($_.name -eq 'USANA')                                                                                   
  51 $projects | where-object ($_.name -eq 'USANA')                                                                                  
  52 $projects                                                                                                                       
  53 $projects.name                                                                                                                  
  54 $projects | ? ($_.name -eq 'website')                                                                                           
  55 $projects[0]                                                                                                                    
  56 $projects | ? ($_.id -eq 7256589)                                                                                               
  57 $projects.GetType()                                                                                                             
  58 $projects | ft -Property id, name, billable                                                                                     
  59 $projects | ? {$_.id -eq 7256589}                                                                                               
  60 $projects | ? {$_.name -eq 'website'}                                                                                           
  61 $projects | ? {$_.name -eq 'admin'}                                                                                             
  62 $projects.Item(340635)                                                                                                          
  63 $projects.Item(3406255)                                                                                                         
  64 $projects                                                                                                                       
  65 $projects | Select-Object id, cid, name                                                                                         
  66 $projects | Select-Object id, cid, name | ? {$_.name -eq 'admin'}                                                               
  67 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  68 C:\pdev\ps\Toggl\Connect-Toggl.ps1                                                                                              
  69 $clients                                                                                                                        
  70 $clents | ? {$_.name -eq 'Intellitect'}                                                                                         
  71 $clents | ? {$_.name -eq 'IntelliTect'}                                                                                         
  72 $clents | ? {$_.name -eq 'Hecla'}                                                                                               
  73 $clients.Address()                                                                                                              
  74 $clients.Item(0)                                                                                                                
  75 $clients.Item('Hecla')                                                                                                          
  76 $clients.Item(2)                                                                                                                
  77 $clents | ? {$_.name -eq 'Hecla'}                                                                                               
  78 $clents | ? {$_.name -eq 'IntelliTect'}                                                                                         
  79 $clients                                                                                                                        
  80 $clients.Where(id -eq 884250)                                                                                                   
  81 $clients.Where( "id -eq 884250" )                                                                                               
  82 $clients.Where( {id -eq 884250} )                                                                                               
  83 $clients.Where( {$_.id -eq 884250} )                                                                                            
  84 $clients.Where( {$_.name -eq 'Hecla'} )                                                                                         
  85 $clients.Where( {$_.name -eq 'Intellitect'} )                                                                                   
  86 $clients.Where( {$_.name -eq 'Intellitect '} )                                                                                  
  87 $clients.Where( {$_.name -eq 'Intellitect'} )                                                                                   
  88 $Projects.Where( {$_.name -like 'admin'} )                                                                                      
  89 $Projects.Where( {$_.name -like 'admin'} ) | select id, name, cid                                                               
  90 $Projects.Where( {$_.name -like 'admin'} ) | select id, name, cid                                                               
  91 $Projects.Where( {$_.name -like 'admin'} ) | select id, name, $clients.where({$_.id = cid})                                     
  92 $Projects.Where( {$_.name -like 'admin'} ) | select id, name, $clients.where({$_.id .eq cid})                                   
  93 $Projects.Where( {$_.name -like 'admin'} ) | select id, name, $clients.where({$_.id -eq cid})                                   
  94 $Projects.Where( {$_.name -like '*admin*'} )                                                                                    
  95 $Projects.Where( {$_.name -like '*admin*'} ) | select name, id                                                                  
  96 $Projects.Where({$_.name -like '*admin*'}) | select name, id                                                                    
  97 $Projects.Where({$_.name -like '*admin*'}) | select name, id, cid                                                               
  98 history                                                                                                                         


