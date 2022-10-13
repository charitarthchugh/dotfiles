local glow_status_ok, glow = pcall(require, "glow")

if not glow_status_ok then
  return
end

glow.setup()
