#!/bin/bash
# n8n Resource Monitor - Shows real-time resource usage

echo "🔍 n8n Resource Monitor"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Press Ctrl+C to stop monitoring"
echo ""

# Check if n8n container is running
if ! docker ps | grep -q "n8n"; then
    echo "❌ n8n container is not running!"
    exit 1
fi

# Continuous monitoring
while true; do
    clear
    echo "🔍 n8n Resource Monitor - $(date '+%Y-%m-%d %H:%M:%S')"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Get container stats (one-time snapshot)
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}" n8n

    echo ""
    echo "📊 Resource Allocation:"
    echo "  • Minimum (Idle):    0.5 CPU cores, 512MB RAM"
    echo "  • Maximum (Active):  6.0 CPU cores, 4GB RAM"
    echo "  • Current usage shown above ↑"
    echo ""

    # Check if n8n is processing workflows
    workflow_status=$(docker exec n8n wget -q -O- http://localhost:5678/healthz 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "✅ n8n Status: Healthy"
    else
        echo "⚠️  n8n Status: Checking..."
    fi

    echo ""
    echo "💡 Tips:"
    echo "  • Low usage? n8n is idle and using minimal resources"
    echo "  • High usage? Workflows are running and scaling up automatically"
    echo "  • View logs: docker-compose logs -f n8n"
    echo ""
    echo "Refreshing in 3 seconds... (Ctrl+C to stop)"

    sleep 3
done
